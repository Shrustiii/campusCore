//
//  GPAViewController.swift
//  CampusCore
//
//  Author: Harshpreet Singh
//  Description:
//  Displays GPA calculation results and animates the result card for visual feedback.
//
import UIKit

class GPAViewController: UIViewController {

    @IBOutlet var lblGPA: UILabel!
    @IBOutlet var resultCardView: UIView!
    
    let engine = GPAEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "GPA"
        resultCardView.layer.cornerRadius = 12
        lblGPA.text = "Tap Calculate GPA"
    }
    
    @IBAction func btnCalculateTapped(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let results = appDelegate.getCourseResultsForGPA()
        let gpa = engine.calculateGPA(courseResults: results)
        lblGPA.text = String(format: "Current GPA: %.2f", gpa)
        
        animateResult()
    }
    
    /*
     Method: animateResult
     Author: Harshpreet Singh
     Purpose:
     Uses a simple scale animation so the GPA card feels more interactive.
    */
    func animateResult() {
        resultCardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 2.0,
                       options: .curveEaseInOut) {
            self.resultCardView.transform = .identity
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
