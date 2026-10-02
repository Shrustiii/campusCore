//
//  Assignment.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Description:
//  Model class that stores assignment information for tracking deadlines and completion status.
//

import UIKit
import Foundation

class Assignment: NSObject {

        // Unique assignment id from SQLite database
        var id: Int?
        
        // Assignment title
        var title: String
        
        // Due date stored as yyyy-MM-dd HH:mm string
        var dueDate: String
        
        // Assignment weight percentage
        var weight: Int
        
        // Related course id
        var courseId: Int
        
        // Assignment status such as Pending or Completed
        var status: String
        
        init(id: Int? = nil, title: String, dueDate: String, weight: Int, courseId: Int, status: String) {
            self.id = id
            self.title = title
            self.dueDate = dueDate
            self.weight = weight
            self.courseId = courseId
            self.status = status
        }
}




////
////  Assignment.swift
////  CampusCore
////
////  Author: Dhruvi Jariwala
////  Description:
////  Model class that stores assignment information for tracking deadlines and completion status.
////
//
//import UIKit
//import Foundation
//
//class Assignment: NSObject {
//
//        // Unique assignment id from SQLite database
//        var id: Int?
//        
//        // Assignment title
//        var title: String
//        
//        // Due date stored as yyyy-MM-dd string
//        var dueDate: String
//        
//        // Assignment weight percentage
//        var weight: Int
//        
//        // Related course id
//        var courseId: Int
//        
//        // Assignment status such as Pending or Completed
//        var status: String
//        
//        init(id: Int? = nil, title: String, dueDate: String, weight: Int, courseId: Int, status: String) {
//            self.id = id
//            self.title = title
//            self.dueDate = dueDate
//            self.weight = weight
//            self.courseId = courseId
//            self.status = status
//        }
//}
