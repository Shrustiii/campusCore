//
//  CourseListViewController.swift
//  CampusCore
//
//  Author: Shrusti Shah
//  Description:
//  Displays all courses in a table view and supports delete functionality.
//

import UIKit

class CourseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
       
       var courses: [Course] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           title = "Courses"
           tableView.dataSource = self
           tableView.delegate = self
           
           loadCourses()
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           loadCourses()
       }
       
       /*
        Method: loadCourses
        Author: Shrusti Shah
        Purpose:
        Fetches courses from the database so the table view always shows current data.
       */
       func loadCourses() {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           courses = appDelegate.getAllCourses()
           tableView.reloadData()
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return courses.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
           let course = courses[indexPath.row]
           cell.textLabel?.text = "\(course.code) - \(course.name)"
           cell.detailTextLabel?.text = "Credits: \(course.credits) | \(course.instructor)"
           return cell
       }
       
       /*
        Method: tableView(commit:forRowAt:)
        Author: Shrusti Shah
        Purpose:
        Deletes a selected course from the database and refreshes the table view.
       */
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               if let id = courses[indexPath.row].id {
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   appDelegate.deleteCourse(courseId: id)
                   loadCourses()
               }
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
