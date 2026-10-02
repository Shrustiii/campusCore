//
//  ReminderManager.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Description:
//  Handles local notification permission requests and scheduling assignment reminders.
//

import UIKit
import Foundation
import UserNotifications

class ReminderManager: NSObject {

        static let shared = ReminderManager()
        
        private override init() {}
        
        /*
         Method: requestPermission
         Author: Dhruvi Jariwala
         Purpose:
         Requests notification permission from the user when the app needs to send reminders.
        */
        func requestPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
                print("Permission granted: \(granted)")
            }
        }
        
        /*
         Method: scheduleAssignmentReminder
         Author: Dhruvi Jariwala
         Purpose:
         Schedules a local notification one day before the due date of an assignment.
        */
        func scheduleAssignmentReminder(for assignment: Assignment) {
            guard let assignmentId = assignment.id else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            guard let dueDate = formatter.date(from: assignment.dueDate) else { return }
            
            // WHY: Reminder is scheduled one day before due date so the student has time to act.
            var reminderDate = Calendar.current.date(byAdding: .day, value: -1, to: dueDate) ?? dueDate
            
            // WHY: If the calculated reminder time is already past, schedule it shortly from now for testing and reliability.
            if reminderDate <= Date() {
                reminderDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Assignment Reminder"
            content.body = "\(assignment.title) is due on \(assignment.dueDate)."
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "assignment_\(assignmentId)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(reminderDate)")
                }
            }
        }
        
        /*
         Method: cancelAssignmentReminder
         Author: Dhruvi Jariwala
         Purpose:
         Removes a previously scheduled reminder when assignment data changes or is deleted.
        */
        func cancelAssignmentReminder(for assignmentId: Int) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["assignment_\(assignmentId)"])
        }
}
