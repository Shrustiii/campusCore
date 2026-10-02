//
//  HomeViewController.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Description:
//  Displays the main home screen after login, shows a welcome message,
//  loads the student's first name as a greeting, and handles logout.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var lblWelcomeTitle: UILabel!
    @IBOutlet var lblGreeting: UILabel!
    @IBOutlet var imgAvatar: UIImageView!
    
    @IBAction func unwindToHomeVC(sender : UIStoryboardSegue) {
        updateSelectedAvatarUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WHY: Set the main heading text when the home screen loads.
        lblWelcomeTitle.text = "Welcome to CampusCore"
        
        loadGreeting()
        updateSelectedAvatarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelectedAvatarUI()
    }
    
    func playButtonSound() {
        SoundManager.shared.playSound(fileName: "buttonPop", fileType: "wav")
    }
    
    /*
     Method: loadGreeting
     Author: Dhruvi Jariwala
     Purpose:
     Loads the saved student name, extracts the first name,
     and displays it as a greeting under the home title.
    */
    func loadGreeting() {
        
        playButtonSound()
        
        let fullName = UserDefaults.standard.string(forKey: "savedName") ?? ""
        
        if fullName.isEmpty {
            lblGreeting.text = "Hello!"
        } else {
            let firstName = fullName.components(separatedBy: " ").first ?? fullName
            lblGreeting.text = "Hello, \(firstName)!"
        }
    }
    
    /*
     Method: updateSelectedAvatarUI
     Author: Dhruvi Jariwala
     Purpose:
     Loads the selected avatar from AppDelegate and shows it
     on the home page above the profile button.
    */
    func updateSelectedAvatarUI() {
        
        playButtonSound()
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if mainDelegate.selectedAvatarName != "" {
            imgAvatar.image = UIImage(named: mainDelegate.selectedAvatarName)
        } else {
            imgAvatar.image = UIImage(named: "profile")
        }
        
//        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        imgAvatar.layer.cornerRadius = 40
        imgAvatar.clipsToBounds = true
    }
    
    /*
     Method: btnLogoutTapped
     Author: Dhruvi Jariwala
     Purpose:
     Shows a confirmation alert before logging the user out
     from the home screen.
    */
    @IBAction func btnLogoutTapped(_ sender: UIBarButtonItem) {
        playButtonSound()
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.goToLoginPage()
        }
        
        let noButton = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true)
    }
    
    /*
     Method: goToLoginPage
     Author: Dhruvi Jariwala
     Purpose:
     Returns the user to the login screen after logout
     and resets the root view controller.
    */
    func goToLoginPage() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }

}
