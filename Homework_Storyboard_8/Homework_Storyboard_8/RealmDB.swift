import Foundation
import RealmSwift

class RealmDB {
    private static let dataBase = try! Realm()
    
    static func addTasksList(tasksList: TaskList) {
        try! dataBase.write {
            dataBase.add(tasksList)
        }
    }
    
    static func addTask(task: Task) {
        try! dataBase.write {
            dataBase.add(task)
        }
    }
}
