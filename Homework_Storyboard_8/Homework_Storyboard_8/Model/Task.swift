import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
    
    convenience init(name: String, note: String) {
        self.init()
        self.name = name
        self.note = note
    }
}
