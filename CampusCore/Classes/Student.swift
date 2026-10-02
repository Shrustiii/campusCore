//
//  Student.swift
//  CampusCore
//
//  Author: Shrusti Shah
//  Description:
//  Model class that stores student profile information and login details.
//

import UIKit
import Foundation

class Student: NSObject {

        // Unique student id from SQLite database
        var id: Int?
        
        // Full name of the student
        var name: String
        
        // Username used for login
        var username: String
        
        // Password used for login
        var password: String
        
        // Program id linked to the program table
        var programId: Int
        
        init(id: Int? = nil, name: String, username: String, password: String, programId: Int) {
            self.id = id
            self.name = name
            self.username = username
            self.password = password
            self.programId = programId
        }
}
