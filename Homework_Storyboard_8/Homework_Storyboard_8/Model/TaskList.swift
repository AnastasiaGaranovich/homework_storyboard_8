import RealmSwift
import Foundation

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    var completedTasksCount: Int {
        (tasks.filter({
            $0.isComplete
        })).count
    }
}
