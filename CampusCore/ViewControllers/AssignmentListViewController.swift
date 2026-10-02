//
//  AssignmentListViewController.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Description:
//  Displays assignments in a table view and allows the user to mark them complete.
//

import UIKit

class AssignmentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func playButtonSound() {
        SoundManager.shared.playSound(fileName: "buttonPop", fileType: "wav")
    }
    
    @IBAction func unwindToALVC(sender : UIStoryboardSegue) {
        playButtonSound()
    }
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentFilter: UISegmentedControl!
        
    var assignments: [Assignment] = []
    var filteredAssignments: [Assignment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Assignments"
        tableView.dataSource = self
        tableView.delegate = self
        
        loadAssignments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAssignments()
    }
    
    /*
     Method: loadAssignments
     Author: Dhruvi Jariwala
     Purpose:
     Loads assignments from the database and applies the selected filter.
    */
    func loadAssignments() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        assignments = appDelegate.getAllAssignments()
        applyFilter()
    }
    
    /*
     Method: applyFilter
     Author: Dhruvi Jariwala
     Purpose:
     Filters assignments by status based on segmented control selection.
    */
    func applyFilter() {
        switch segmentFilter.selectedSegmentIndex {
        case 1:
            filteredAssignments = assignments.filter { $0.status == "Pending" }
        case 2:
            filteredAssignments = assignments.filter { $0.status == "Completed" }
        default:
            filteredAssignments = assignments
        }
        
        tableView.reloadData()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        applyFilter()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredAssignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell", for: indexPath)
        let item = filteredAssignments[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = "Due: \(item.dueDate) | Weight: \(item.weight)% | \(item.status)"
        cell.accessoryType = item.status == "Completed" ? .checkmark : .none
        
        return cell
    }
    
    /*
     Method: tableView(didSelectRowAt:)
     Author: Dhruvi Jariwala
     Purpose:
     Marks a pending assignment complete, updates the database, and plays a completion sound.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredAssignments[indexPath.row]
        
        if item.status == "Pending", let id = item.id {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.updateAssignmentStatus(assignmentId: id, newStatus: "Completed")
            
            // WHY: A success sound gives the user instant feedback that the task was finished.
            SoundManager.shared.playSound(fileName: "successPop", fileType: "wav")
            
            ReminderManager.shared.cancelAssignmentReminder(for: id)
            loadAssignments()
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
