//
//  AvatarViewController.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Description:
//  Allows the student to select an avatar, preview it,
//  and save it for display on the profile and home pages.
//

import UIKit

class AvatarViewController: UIViewController {

    @IBOutlet var lblSelectedAvatar: UILabel!
    @IBOutlet var previewImageView: UIImageView!
    
    var currentAvatar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        
        // WHY: Load previously selected avatar if available
        if mainDelegate.selectedAvatarName != "" {
            currentAvatar = mainDelegate.selectedAvatarName
            lblSelectedAvatar.text = "Selected Avatar: \(currentAvatar)"
            previewImageView.image = UIImage(named: currentAvatar)
        } else {
            lblSelectedAvatar.text = "Selected Avatar: None"
            previewImageView.image = nil
        }
    }
    
    func playButtonSound() {
        SoundManager.shared.playSound(fileName: "buttonPop", fileType: "wav")
    }
    
    
    /*
     Method: avatar1Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar1 and updates preview.
    */
    @IBAction func avatar1Tapped(_ sender: UIButton) {
        currentAvatar = "av1"
        lblSelectedAvatar.text = "Selected Avatar: av1"
        previewImageView.image = UIImage(named: "av1")
    }
//    @IBAction func avatar1Tapped(_ sender: UIButton) {
//        lblSelectedAvatar.text = "Selected Avatar: av1"
//        previewImageView.image = sender.image(for: .normal)
//    }
    /*
     Method: avatar2Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar2 and updates preview.
    */
    @IBAction func avatar2Tapped(_ sender: UIButton) {
        currentAvatar = "av2"
        lblSelectedAvatar.text = "Selected Avatar: av2"
        previewImageView.image = UIImage(named: "av2")
    }
    
    /*
     Method: avatar3Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar3 and updates preview.
    */
    @IBAction func avatar3Tapped(_ sender: UIButton) {
        currentAvatar = "av3"
        lblSelectedAvatar.text = "Selected Avatar: av3"
        previewImageView.image = UIImage(named: "av3")
    }
    
    /*
     Method: avatar4Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar4 and updates preview.
    */
    @IBAction func avatar4Tapped(_ sender: UIButton) {
        currentAvatar = "av4"
        lblSelectedAvatar.text = "Selected Avatar: av4"
        previewImageView.image = UIImage(named: "av4")
    }
    
    /*
     Method: avatar5Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar5 and updates preview.
    */
    @IBAction func avatar5Tapped(_ sender: UIButton) {
        currentAvatar = "av5"
        lblSelectedAvatar.text = "Selected Avatar: av5"
        previewImageView.image = UIImage(named: "av5")
    }
    
    /*
     Method: avatar6Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar6 and updates preview.
    */
    @IBAction func avatar6Tapped(_ sender: UIButton) {
        currentAvatar = "av6"
        lblSelectedAvatar.text = "Selected Avatar: av6"
        previewImageView.image = UIImage(named: "av6")
    }
    
    /*
     Method: avatar7Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar7 and updates preview.
    */
    @IBAction func avatar7Tapped(_ sender: UIButton) {
        currentAvatar = "av7"
        lblSelectedAvatar.text = "Selected Avatar: av7"
        previewImageView.image = UIImage(named: "av7")
    }
    
    /*
     Method: avatar8Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar8 and updates preview.
    */
    @IBAction func avatar8Tapped(_ sender: UIButton) {
        currentAvatar = "av8"
        lblSelectedAvatar.text = "Selected Avatar: av8"
        previewImageView.image = UIImage(named: "av8")
    }
    
    /*
     Method: avatar9Tapped
     Author: Dhruvi Jariwala
     Purpose:
     Selects avatar9 and updates preview.
    */
    @IBAction func avatar9Tapped(_ sender: UIButton) {
        currentAvatar = "av9"
        lblSelectedAvatar.text = "Selected Avatar: av9"
        previewImageView.image = UIImage(named: "av9")
    }
    
    /*
     Method: btnDoneTapped
     Author: Dhruvi Jariwala
     Purpose:
     Saves the selected avatar and returns to the previous screen.
    */
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        
        playButtonSound()
        
        if currentAvatar == "" {
            let alert = UIAlertController(title: "Avatar", message: "Please select an avatar first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.selectedAvatarName = currentAvatar
        
        let alert = UIAlertController(title: "Avatar Selected", message: "Your avatar has been selected successfully.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    /*
     Method: btnBackTapped
     Author: Dhruvi Jariwala
     Purpose:
     Returns to the previous screen without saving changes.
    */
    @IBAction func btnBackTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // Default navigation method (not used here).
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */
}
