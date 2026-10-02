//
//  Course.swift
//  CampusCore
//
//  Author: Shrusti Shah
//  Description:
//  Model class that stores course details for the Course Management module.
//

import UIKit
import Foundation

class Course: NSObject {

        // Unique course id from SQLite database
        var id: Int?
        
        // Course name, such as Mobile App Development
        var name: String
        
        // Unique course code, such as PROG30000
        var code: String
        
        // Number of credits for the course
        var credits: Int
        
        // Program id linked to program table
        var programId: Int
        
        // Instructor name for the course
        var instructor: String
        
        init(id: Int? = nil, name: String, code: String, credits: Int, programId: Int, instructor: String) {
            self.id = id
            self.name = name
            self.code = code
            self.credits = credits
            self.programId = programId
            self.instructor = instructor
        }
}
