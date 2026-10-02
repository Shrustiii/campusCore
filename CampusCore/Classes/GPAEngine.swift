//
//  GPAEngine.swift
//  CampusCore
//
//  Author: Harshpreet Singh
//  Description:
//  Performs GPA calculations based on numeric grades from the database.
//

import UIKit
import Foundation

class GPAEngine: NSObject {

    /*
     Method: gradeToPoint
     Author: Harshpreet Singh
     Purpose:
     Converts a numeric grade into a GPA point value.
    */
    func gradeToPoint(_ grade: Double) -> Double {
        switch grade {
        case 90...100: return 4.0
        case 85..<90: return 4.0
        case 80..<85: return 3.7
        case 77..<80: return 3.3
        case 73..<77: return 3.0
        case 70..<73: return 2.7
        case 67..<70: return 2.3
        case 63..<67: return 2.0
        case 60..<63: return 1.7
        case 57..<60: return 1.3
        case 53..<57: return 1.0
        case 50..<53: return 0.7
        default: return 0.0
        }
    }
    
    /*
     Method: calculateGPA
     Author: Harshpreet Singh
     Purpose:
     Calculates weighted GPA using course credits and final numeric grades.
    */
    func calculateGPA(courseResults: [(grade: Double, credits: Int)]) -> Double {
        var totalPoints = 0.0
        var totalCredits = 0
        
        for result in courseResults {
            totalPoints += gradeToPoint(result.grade) * Double(result.credits)
            totalCredits += result.credits
        }
        
        guard totalCredits > 0 else { return 0.0 }
        return totalPoints / Double(totalCredits)
    }
}
