//
//  LoginViewController.swift
//  CampusCore
//
//  Author: Shrusti Shah
//  Description:
//  Handles user login, validation, error handling, and biometric authentication.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var btnBiometric: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let username = defaults.object(forKey: "savedUsername") as? String {
            txtUsername.text = username
        }
        
        if let password = defaults.object(forKey: "savedPassword") as? String {
            txtPassword.text = password
        }

        // WHY: Hide any previous message when the screen loads.
        lblMessage.text = ""
                
        styleUI()
        btnBiometric.isHidden = false
        checkBiometricAvailability()
        
        txtUsername.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
            
    /*
     Method: styleUI
     Author: Shrusti Shah
     Purpose:
     Applies rounded corners and basic styling to controls.
    */
    func styleUI() {
        txtUsername.layer.cornerRadius = 8
        txtPassword.layer.cornerRadius = 8
        btnBiometric.layer.cornerRadius = 8
    }
            
    /*
     Method: checkBiometricAvailability
     Author: Shrusti Shah
     Purpose:
     Checks whether Face ID / Touch ID can be used on the current device.
    */
    func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?
                
        let available = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        btnBiometric.isHidden = !available
//        btnBiometric.isHidden = false
        
        if let error = error {
            print("Biometric availability error: \(error.localizedDescription)")
        }
        
        print("Biometric available: \(available)")
    }
    
    func playButtonSound() {
        SoundManager.shared.playSound(fileName: "buttonPop", fileType: "wav")
    }
    
    /*
     Method: btnLoginTapped
     Author: Shrusti Shah
     Purpose:
     Validates login fields and authenticates the student using the database.
    */
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        playButtonSound()
            
        // WHY: Old error text should not remain visible during a new login attempt.
        lblMessage.text = ""
            
        guard let username = txtUsername.text, !username.isEmpty,
              let password = txtPassword.text, !password.isEmpty else {
            lblMessage.text = "Please enter username and password."
            showAlert(title: "Missing Details", message: "Please enter username and password.")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
        if let student = appDelegate.validateStudent(username: username, password: password) {
                
            // WHY: Store student information locally so biometric login can reopen the app faster.
            UserDefaults.standard.set(student.username, forKey: "savedUsername")
            UserDefaults.standard.set(student.password, forKey: "savedPassword")
            UserDefaults.standard.set(true, forKey: "biometricEnabled")
            UserDefaults.standard.set(student.name, forKey: "savedName")
            UserDefaults.standard.set("Program \(student.programId)", forKey: "savedProgram")
            UserDefaults.standard.synchronize()
            
            showAlert(title: "Login Successful", message: "Welcome back to CampusCore.") {
                self.goToMainApp()
            }
        } else {
            lblMessage.text = "Invalid login credentials."
            showAlert(title: "Login Failed", message: "Invalid login credentials.")
        }
    }
        
    /*
     Method: btnBiometricTapped
     Author: Shrusti Shah
     Purpose:
     Authenticates the user using Face ID or Touch ID and logs in using saved credentials.
    */
    @IBAction func btnBiometricTapped(_ sender: UIButton) {
        authenticateWithBiometrics()
    }
        
    /*
     Method: authenticateWithBiometrics
     Author: Shrusti Shah
     Purpose:
     Uses LocalAuthentication framework to allow biometric login.
    */
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
            
        guard UserDefaults.standard.bool(forKey: "biometricEnabled") else {
            lblMessage.text = "Biometric login has not been enabled yet."
            showAlert(title: "Biometric Login", message: "Please log in once with username and password first.")
            return
        }
            
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            lblMessage.text = "Biometric authentication is not available."
            showAlert(title: "Biometric Login", message: "Face ID / Touch ID is not available on this device.")
            if let error = error {
                print("Biometric evaluate error: \(error.localizedDescription)")
            }
            return
        }
            
        let reason = "Use Face ID / Touch ID to log in to CampusCore."
            
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                if success {
                    let username = UserDefaults.standard.string(forKey: "savedUsername") ?? ""
                    let password = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                    if appDelegate.validateStudent(username: username, password: password) != nil {
                        self.showAlert(title: "Login Successful", message: "Biometric authentication successful.") {
                            self.goToMainApp()
                        }
                    } else {
                        self.lblMessage.text = "Saved credentials are no longer valid."
                        self.showAlert(title: "Biometric Login", message: "Saved credentials are no longer valid.")
                    }
                } else {
                    self.lblMessage.text = "Biometric authentication failed."
                    self.showAlert(title: "Biometric Login", message: "Biometric authentication failed.")
                }
            }
        }
    }
        
    /*
     Method: goToMainApp
     Author: Shrusti Shah
     Purpose:
     Navigates the user to the main tab bar after successful authentication.
    */
    func goToMainApp() {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true)
        }
    }
    
    @objc func textFieldDidChange() {
        UserDefaults.standard.set(txtUsername.text ?? "", forKey: "savedUsername")
        UserDefaults.standard.set(txtPassword.text ?? "", forKey: "savedPassword")
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

