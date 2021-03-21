import UIKit
import RealmSwift

class TasksTableViewController: UITableViewController {
    
    var task: TaskList!
    
    private var completed: Results<Task>!
    private var uncompleted: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        completed   = task.tasks.filter("isComplete = true")
        uncompleted = task.tasks.filter("isComplete = false")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func editTaskButtonPressed(_ sender: UIBarButtonItem) {
    
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Enter task's name"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter task's note"
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            let nameTextField = alert.textFields![0]
            let noteTextField = alert.textFields![1]
            try! RealmDB.dataBase.write {
                self.task.tasks.append(Task(name: nameTextField.text ?? "No name", note: noteTextField.text ?? "None"))
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Uncompleted"
        }
        if section == 1 {
            return "Completed"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForSection(numberOfSection: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")!
        let task = arrayForSection(numberOfSection: indexPath.section)[indexPath.row]
        cell.textLabel?.text       = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }
    
    private func arrayForSection(numberOfSection: Int) -> Results<Task> {
        if numberOfSection == 0 {
            return uncompleted
        }
        else {
            return completed
        }
    }
}
