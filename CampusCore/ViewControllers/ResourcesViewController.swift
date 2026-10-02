//
//  ResourcesViewController.swift
//  CampusCore
//
//  Author: Harshpreet Singh
//  Description:
//  Displays academic resources inside a WKWebView.
//

import UIKit
import WebKit

class ResourcesViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resources"  //WHY: Set the screen title when the view loads.
        
        // WHY: Web view delegate is needed so loading spinner can be shown and hidden.
        activity.isHidden = true
        let urlAddress = URL(string: "https://www.campus-core.com")
        let url = URLRequest(url: urlAddress!)

        webView.load(url)
        webView.navigationDelegate = self
    }
    
    func playButtonSound() {
        SoundManager.shared.playSound(fileName: "buttonPop", fileType: "wav")
    }
    
    /*
     Method: loadSheridanSite
     Author: Harshpreet Singh
     Purpose:
     Opens an academic resource website when the resources screen appears.
    */
    @IBAction func btnSheridanTapped(_ sender: UIButton) {
        playButtonSound()
        if let url = URL(string: "https://www.sheridancollege.ca") {
            webView.load(URLRequest(url: url))
        }
    }
    
    @IBAction func btnGithubTapped(_ sender: UIButton) {
        playButtonSound()
        if let url = URL(string: "https://github.com") {
            webView.load(URLRequest(url: url))
        }
    }
    
    @IBAction func btnLibraryTapped(_ sender: UIButton) {
        playButtonSound()
        let urlAddress = URL(string: "https://library.sheridancollege.ca")
        let url = URLRequest(url: urlAddress!)
        webView.load(url)
    }
    
    // Start loading
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        activity.isHidden = false
        activity.startAnimating()
    }

    // Finished loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
        activity.isHidden = true
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
