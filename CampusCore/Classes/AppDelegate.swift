//
//  AppDelegate.swift
//  CampusCore
//
//  Author: Dhruvi Jariwala
//  Primary Author: Dhruvi Jariwala
//  Contributors: Shrusti Shah, Harshpreet Singh
//  Description:
//  Handles application startup tasks and prepares the SQLite database
//  by copying it from the app bundle to the Documents directory.
//  Manages SQLite CRUD operations and queries for CampusCore.
//

import UIKit
import SQLite3
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var databaseName: String = "campuscoredb.db"
    var databasePath: String = ""
    var selectedAvatarName: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // WHY: Create the writable path for the bundled SQLite database.
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName)
        
        checkAndCreateDatabase()
        requestNotificationPermission()
        
        // WHY: Assign the notification center delegate so alerts can appear while the app is in use.
        UNUserNotificationCenter.current().delegate = self
        
        print("Database Path: \(databasePath)")
        
        return true
    }
    
    /*
     Method: checkAndCreateDatabase
     Author: Dhruvi Jariwala
     Purpose:
     Checks whether the database already exists in the Documents directory.
     If not, it copies the bundled database from the app resources.
    */
    func checkAndCreateDatabase() {
        let fileManager = FileManager.default
        
        let success = fileManager.fileExists(atPath: databasePath)
        
        if success {
            print("Database already exists at path: \(databasePath)")
            return
        }
        
        // WHY: The bundled database is read-only, so it must be copied to Documents
        // before the app can insert, update, or delete records.
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName)
        
        guard let fromPath = databasePathFromApp else {
            print("Could not find database in app bundle.")
            return
        }
        
        do {
            try fileManager.copyItem(atPath: fromPath, toPath: databasePath)
            print("Database copied successfully.")
        } catch {
            print("Could not copy database: \(error.localizedDescription)")
        }
    }
    
    /*
     Method: requestNotificationPermission
     Author: Dhruvi Jariwala
     Purpose:
     Requests user permission for local notifications used in assignment reminders.
    */
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    /*
     Method: userNotificationCenter
     Author: Dhruvi Jariwala
     Purpose:
     Allows local notifications to appear as alerts and play sounds
     even when the application is currently open in the foreground.
    */
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    /*
     Method: openDatabase
     Author: Harshpreet Singh
     Purpose:
     Opens the SQLite database using the database path prepared in AppDelegate.
    */
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            print("Database opened successfully at \(databasePath)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    /*
     Method: validateStudent
     Author: Shrusti Shah
     Purpose:
     Confirms login credentials and returns a matching student object when valid.
    */
    func validateStudent(username: String, password: String) -> Student? {
        guard let db = openDatabase() else { return nil }
        
        let query = "SELECT id, name, username, password, programid FROM student WHERE username = ? AND password = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let uname = String(cString: sqlite3_column_text(statement, 2))
                let pwd = String(cString: sqlite3_column_text(statement, 3))
                let programId = Int(sqlite3_column_int(statement, 4))
                
                sqlite3_finalize(statement)
                sqlite3_close(db)
                
                return Student(id: id, name: name, username: uname, password: pwd, programId: programId)
            }
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        return nil
    }
    
    /*
     Method: getAllCourses
     Author: Shrusti Shah
     Purpose:
     Returns all course records from the course table.
    */
    func getAllCourses() -> [Course] {
        var courses: [Course] = []
        guard let db = openDatabase() else { return courses }
        
        let query = "SELECT id, name, code, credits, programid, instructor FROM course"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let course = Course(
                    id: Int(sqlite3_column_int(statement, 0)),
                    name: String(cString: sqlite3_column_text(statement, 1)),
                    code: String(cString: sqlite3_column_text(statement, 2)),
                    credits: Int(sqlite3_column_int(statement, 3)),
                    programId: Int(sqlite3_column_int(statement, 4)),
                    instructor: String(cString: sqlite3_column_text(statement, 5))
                )
                courses.append(course)
            }
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        return courses
    }
    
    /*
     Method: insertCourse
     Author: Shrusti Shah
     Purpose:
     Inserts a new course record into the course table.
    */
    func insertCourse(course: Course) -> Bool {
        guard let db = openDatabase() else { return false }
        
        let query = "INSERT INTO course (name, code, credits, programid, instructor) VALUES (?, ?, ?, ?, ?)"
        var statement: OpaquePointer?
        var result = false
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (course.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (course.code as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(course.credits))
            sqlite3_bind_int(statement, 4, Int32(course.programId))
            sqlite3_bind_text(statement, 5, (course.instructor as NSString).utf8String, -1, nil)
            
            result = sqlite3_step(statement) == SQLITE_DONE
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        return result
    }
    
    /*
     Method: deleteCourse
     Author: Shrusti Shah
     Purpose:
     Deletes a course record using its id.
    */
    func deleteCourse(courseId: Int) {
        guard let db = openDatabase() else { return }
        
        let query = "DELETE FROM course WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(courseId))
            sqlite3_step(statement)
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
    }
    
    /*
     Method: getAllAssignments
     Author: Dhruvi Jariwala
     Purpose:
     Returns all assignment records from the assignment table.
    */
    func getAllAssignments() -> [Assignment] {
        var list: [Assignment] = []
        guard let db = openDatabase() else { return list }
        
        let query = "SELECT id, title, duedate, weight, courseid, status FROM assignment"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let item = Assignment(
                    id: Int(sqlite3_column_int(statement, 0)),
                    title: String(cString: sqlite3_column_text(statement, 1)),
                    dueDate: String(cString: sqlite3_column_text(statement, 2)),
                    weight: Int(sqlite3_column_int(statement, 3)),
                    courseId: Int(sqlite3_column_int(statement, 4)),
                    status: String(cString: sqlite3_column_text(statement, 5))
                )
                list.append(item)
            }
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        return list
    }
    
    /*
     Method: insertAssignment
     Author: Dhruvi Jariwala
     Purpose:
     Inserts a new assignment record and returns the inserted row id.
    */
    func insertAssignment(assignment: Assignment) -> Int? {
        guard let db = openDatabase() else { return nil }
        
        let query = "INSERT INTO assignment (title, duedate, weight, courseid, status) VALUES (?, ?, ?, ?, ?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (assignment.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (assignment.dueDate as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(assignment.weight))
            sqlite3_bind_int(statement, 4, Int32(assignment.courseId))
            sqlite3_bind_text(statement, 5, (assignment.status as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                let id = Int(sqlite3_last_insert_rowid(db))
                sqlite3_finalize(statement)
                sqlite3_close(db)
                return id
            }
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        return nil
    }
    
    /*
     Method: updateAssignmentStatus
     Author: Dhruvi Jariwala
     Purpose:
     Updates an assignment status such as Pending or Completed.
    */
    func updateAssignmentStatus(assignmentId: Int, newStatus: String) {
        guard let db = openDatabase() else { return }
        
        let query = "UPDATE assignment SET status = ? WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (newStatus as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(assignmentId))
            sqlite3_step(statement)
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
    }
    
    /*
     Method: getCourseResultsForGPA
     Author: Harshpreet Singh
     Purpose:
     Returns course average grade and course credits needed for GPA calculation.
    */
    func getCourseResultsForGPA() -> [(grade: Double, credits: Int)] {
        var results: [(grade: Double, credits: Int)] = []
        guard let db = openDatabase() else { return results }
        
        let query = """
        SELECT AVG(g.grade) AS average_grade, c.credits
        FROM grades g
        JOIN studentcourse sc ON g.studentcourseid = sc.id
        JOIN course c ON sc.courseid = c.id
        GROUP BY c.id
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let avgGrade = sqlite3_column_double(statement, 0)
                let credits = Int(sqlite3_column_int(statement, 1))
                results.append((avgGrade, credits))
            }
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        return results
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
