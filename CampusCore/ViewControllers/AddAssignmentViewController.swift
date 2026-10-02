//
//  AddAssignmentViewController.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Description:
//  Allows the user to add a new assignment, choose a due date and course, and schedule a reminder.
//

import UIKit

class AddAssignmentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var txtWeight: UITextField!
    @IBOutlet var coursePicker: UIPickerView!
    @IBOutlet var switchReminder: UISwitch!
    @IBOutlet var lblMessage: UILabel!
    
    var courses: [Course] = []
    var selectedCourseId: Int = 1
    
    func playButtonSound() {
        SoundManager.shared.playSound(fileName: "buttonPop", fileType: "wav")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Assignment"
        lblMessage.text = ""
        
        coursePicker.dataSource = self
        coursePicker.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        courses = appDelegate.getAllCourses()
        
        if let first = courses.first, let id = first.id {
            selectedCourseId = id
        }
        
        datePicker.datePickerMode = .dateAndTime
        
        loadSavedFormData()
        
        if let savedCourseId = UserDefaults.standard.object(forKey: "assignmentSelectedCourseId") as? Int {
            selectedCourseId = savedCourseId
            
            for index in 0..<courses.count {
                if courses[index].id == savedCourseId {
                    coursePicker.selectRow(index, inComponent: 0, animated: false)
                    break
                }
            }
        }
        
        ReminderManager.shared.requestPermission()
        
        txtTitle.addTarget(self, action: #selector(formValueChanged), for: .editingChanged)
        txtWeight.addTarget(self, action: #selector(formValueChanged), for: .editingChanged)
        datePicker.addTarget(self, action: #selector(formValueChanged), for: .valueChanged)
        switchReminder.addTarget(self, action: #selector(formValueChanged), for: .valueChanged)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        courses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(courses[row].code) - \(courses[row].name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCourseId = courses[row].id ?? 1
        saveFormData()
    }
    
    @IBAction func btnSaveTapped(_ sender: UIBarButtonItem) {
        playButtonSound()
            guard let title = txtTitle.text, !title.isEmpty,
                  let weightText = txtWeight.text, !weightText.isEmpty else {
                lblMessage.text = "Please complete all fields."
                showAlert(title: "Missing Details", message: "Please complete all fields.")
                return
            }
            
            let cleanedWeightText = weightText.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let weight = Int(cleanedWeightText) else {
                lblMessage.text = "Please enter a valid weight."
                showAlert(title: "Invalid Weight", message: "Please enter weight as a number, such as 20 or 20%.")
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dueDate = formatter.string(from: datePicker.date)
            
            let assignment = Assignment(title: title,
                                        dueDate: dueDate,
                                        weight: weight,
                                        courseId: selectedCourseId,
                                        status: "Pending")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let newId = appDelegate.insertAssignment(assignment: assignment) {
                assignment.id = newId
                
                if switchReminder.isOn {
                    ReminderManager.shared.scheduleAssignmentReminder(for: assignment)
                }
                
                clearSavedFormData()
                
                showAlert(title: "Assignment Saved", message: "The assignment was added successfully.") {
                    self.dismiss(animated: true)
                }
            } else {
                lblMessage.text = "Unable to save assignment."
                showAlert(title: "Save Failed", message: "Unable to save assignment.")
            }
        }
    
    func loadSavedFormData() {
        txtTitle.text = UserDefaults.standard.string(forKey: "assignmentTitle") ?? ""
        txtWeight.text = UserDefaults.standard.string(forKey: "assignmentWeight") ?? ""
        switchReminder.isOn = UserDefaults.standard.bool(forKey: "assignmentReminder")
        
        if let savedDate = UserDefaults.standard.object(forKey: "assignmentDueDate") as? Date {
            datePicker.date = savedDate
        }
    }
    
    func saveFormData() {
        UserDefaults.standard.set(txtTitle.text ?? "", forKey: "assignmentTitle")
        UserDefaults.standard.set(txtWeight.text ?? "", forKey: "assignmentWeight")
        UserDefaults.standard.set(datePicker.date, forKey: "assignmentDueDate")
        UserDefaults.standard.set(switchReminder.isOn, forKey: "assignmentReminder")
        UserDefaults.standard.set(selectedCourseId, forKey: "assignmentSelectedCourseId")
    }
    
    func clearSavedFormData() {
        UserDefaults.standard.removeObject(forKey: "assignmentTitle")
        UserDefaults.standard.removeObject(forKey: "assignmentWeight")
        UserDefaults.standard.removeObject(forKey: "assignmentDueDate")
        UserDefaults.standard.removeObject(forKey: "assignmentReminder")
        UserDefaults.standard.removeObject(forKey: "assignmentSelectedCourseId")
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

