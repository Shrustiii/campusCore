//
//  AddCourseViewController.swift
//  CampusCore
//
//  Author: Shrusti Shah
//  Description:
//  Allows the user to add a new course to the SQLite database.
//

import UIKit

class AddCourseViewController: UIViewController {

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtCode: UITextField!
    @IBOutlet var txtCredits: UITextField!
    @IBOutlet var txtInstructor: UITextField!
    @IBOutlet var lblMessage: UILabel!
    
    func playButtonSound() {
        SoundManager.shared.playSound(fileName: "buttonPop", fileType: "wav")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Course"
        lblMessage.text = ""
        
        loadSavedFormData()
        
        txtName.addTarget(self, action: #selector(formValueChanged), for: .editingChanged)
        txtCode.addTarget(self, action: #selector(formValueChanged), for: .editingChanged)
        txtCredits.addTarget(self, action: #selector(formValueChanged), for: .editingChanged)
        txtInstructor.addTarget(self, action: #selector(formValueChanged), for: .editingChanged)
    }
    
    @IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
        playButtonSound()
        dismiss(animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: UIBarButtonItem) {
        playButtonSound()
            guard let name = txtName.text, !name.isEmpty,
                  let code = txtCode.text, !code.isEmpty,
                  let creditsText = txtCredits.text, let credits = Int(creditsText),
                  let instructor = txtInstructor.text, !instructor.isEmpty else {
                lblMessage.text = "Please complete all fields."
                showAlert(title: "Missing Details", message: "Please complete all fields.")
                return
            }
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let course = Course(name: name, code: code, credits: credits, programId: 1, instructor: instructor)
            let success = appDelegate.insertCourse(course: course)
            
            if success {
                clearSavedFormData()
                showAlert(title: "Course Saved", message: "The course was added successfully.") {
                    self.dismiss(animated: true)
                }
            } else {
                lblMessage.text = "Could not save course."
                showAlert(title: "Save Failed", message: "Could not save course.")
            }
        }
    
    func loadSavedFormData() {
        txtName.text = UserDefaults.standard.string(forKey: "courseName") ?? ""
        txtCode.text = UserDefaults.standard.string(forKey: "courseCode") ?? ""
        txtCredits.text = UserDefaults.standard.string(forKey: "courseCredits") ?? ""
        txtInstructor.text = UserDefaults.standard.string(forKey: "courseInstructor") ?? ""
    }
    
    func saveFormData() {
        UserDefaults.standard.set(txtName.text ?? "", forKey: "courseName")
        UserDefaults.standard.set(txtCode.text ?? "", forKey: "courseCode")
        UserDefaults.standard.set(txtCredits.text ?? "", forKey: "courseCredits")
        UserDefaults.standard.set(txtInstructor.text ?? "", forKey: "courseInstructor")
    }
    
    func clearSavedFormData() {
        UserDefaults.standard.removeObject(forKey: "courseName")
        UserDefaults.standard.removeObject(forKey: "courseCode")
        UserDefaults.standard.removeObject(forKey: "courseCredits")
        UserDefaults.standard.removeObject(forKey: "courseInstructor")
    }
    
    @objc func formValueChanged() {
        saveFormData()
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        
        SoundManager.shared.playSound(fileName: "notificationPop", fileType: "wav")
        
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

