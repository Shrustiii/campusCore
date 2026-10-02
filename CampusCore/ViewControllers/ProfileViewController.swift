//
//  ProfileViewController.swift
//  CampusCore
//
//  Author: Harshpreet Singh, Dhruvi Jariwala
//  Description:
//  Shows student profile information and exports GPA report as a PDF.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblProgram: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        loadProfile()
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
     Method: loadProfile
     Author: Harshpreet Singh
     Purpose:
     Loads saved student info into the profile screen.
    */
    func loadProfile() {
        lblName.text = UserDefaults.standard.string(forKey: "savedName") ?? "Student Name"
        lblUsername.text = UserDefaults.standard.string(forKey: "savedUsername") ?? "Username"
        lblProgram.text = UserDefaults.standard.string(forKey: "savedProgram") ?? "Program"
    }
    
    /*
     Method: updateSelectedAvatarUI
     Author: Dhruvi Jariwala
     Purpose:
     Loads the selected avatar from AppDelegate and shows it
     at the top of the profile page.
    */
    func updateSelectedAvatarUI() {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if mainDelegate.selectedAvatarName != "" {
            imgAvatar.image = UIImage(named: mainDelegate.selectedAvatarName)
        } else {
            imgAvatar.image = UIImage(named: "profile")
        }
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        imgAvatar.clipsToBounds = true
    }
    
    /*
     Method: btnSelectAvatarTapped
     Author: Dhruvi Jariwala
     Purpose:
     Opens the avatar selection page so the student can choose
     a profile avatar.
    */
    @IBAction func btnSelectAvatarTapped(_ sender: UIButton) {
        playButtonSound()
        if let avatarVC = storyboard?.instantiateViewController(withIdentifier: "AvatarViewController") {
            avatarVC.modalPresentationStyle = .fullScreen
            present(avatarVC, animated: true)
        }
    }
    
    @IBAction func btnExportPDFTapped(_ sender: UIBarButtonItem) {
        playButtonSound()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let results = appDelegate.getCourseResultsForGPA()
        let gpa = GPAEngine().calculateGPA(courseResults: results)
        
        let reportText = """
        CampusCore Academic Summary
        
        Name: \(lblName.text ?? "")
        Username: \(lblUsername.text ?? "")
        Program: \(lblProgram.text ?? "")
        GPA: \(String(format: "%.2f", gpa))
        """
        
        exportPDF(reportText: reportText)
    }
    
    /*
     Method: exportPDF
     Author: Harshpreet Singh
     Purpose:
     Generates a PDF file and presents a share sheet for exporting the academic report.
    */
    func exportPDF(reportText: String) {
        playButtonSound()
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18)
            ]
            
            // WHY: Draw the report text directly into the PDF page for a simple academic summary.
            reportText.draw(at: CGPoint(x: 40, y: 60), withAttributes: attributes)
        }
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("CampusCore_GPA_Report.pdf")
        
        do {
            try data.write(to: fileURL)
            let activity = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            present(activity, animated: true)
        } catch {
            print("PDF export failed: \(error.localizedDescription)")
        }
    }
    
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
