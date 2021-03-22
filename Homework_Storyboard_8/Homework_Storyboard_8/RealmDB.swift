import Foundation
import RealmSwift

class RealmDB {
    static let dataBase = try! Realm()
    
    static func addTasksList(tasksList: TaskList) {
        try! dataBase.write {
            dataBase.add(tasksList)
        }
    }
    
    static func addTask(taskList: TaskList, name: String, note: String) {
        try! dataBase.write {
            taskList.tasks.append(Task(name: name, note: note))
        }
    }
    
    static func deleteTaskList(taskList: TaskList) {
        try! dataBase.write {
            dataBase.delete(taskList.tasks)
            dataBase.delete(taskList)
        }
    }
    
    static func deleteTask(task: Task) {
        try! dataBase.write {
            dataBase.delete(task)
        }
    }
    
    static func taskListAllDone(taskList: TaskList) {
        try! dataBase.write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    static func taskDone(task: Task) {
        try! dataBase.write {
            task.isComplete.toggle()
        }
    }
    
    static func editTaskList(taskList: TaskList) {
        
    }
    
    static func editTask(task: Task) {
        
    }
}
