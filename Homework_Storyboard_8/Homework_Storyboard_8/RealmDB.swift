import Foundation
import RealmSwift

class RealmDB {
    static let dataBase = try! Realm()
    
    static func addTasksList(tasksList: TaskList) {
        try! dataBase.write {
            dataBase.add(tasksList)
        }
    }
    
}
