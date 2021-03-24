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
            RealmDB.addTask(taskList: self.task, name: nameTextField.text ?? "No name", note: noteTextField.text ?? "None")
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = arrayForSection(numberOfSection: indexPath.section)[indexPath.row]
        RealmDB.deleteTask(task: task)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = arrayForSection(numberOfSection: indexPath.section)[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            RealmDB.deleteTask(task: task)
            tableView.reloadData()
        }
        
        let editContextItem = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let alert = UIAlertController(title: "Edit Task", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {textField in
                textField.placeholder = "Enter task's name"
            })
            alert.addTextField(configurationHandler: {textField in
                textField.placeholder = "Enter task's note"
            })
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
                let nameTextField = alert.textFields![0]
                let noteTextField = alert.textFields![1]
                RealmDB.editTask(task: task, name: nameTextField.text ?? "No name", note: noteTextField.text ?? "None")
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let doneContextItem = UIContextualAction(style: .normal, title: "Done") { (_, _, _) in
            RealmDB.taskDone(task: task)
            tableView.reloadData()
        }
        
        editContextItem.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        doneContextItem.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        return swipeActions
    }
}
