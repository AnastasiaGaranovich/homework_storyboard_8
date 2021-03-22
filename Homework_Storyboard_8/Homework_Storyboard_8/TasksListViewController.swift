import UIKit

class TasksListViewController: UIViewController {
    @IBOutlet weak var filterTasksListControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var taskLists = RealmDB.dataBase.objects(TaskList.self)
    
    @IBAction func addTasksListButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Tasks List", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Enter tasks list's name"
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            let textField = alert.textFields!.first!
            RealmDB.addTasksList(tasksList: TaskList(name: textField.text ?? "No name"))
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func filterTaskList(_ sender: UISegmentedControl) {
        //сделать сортировку по нажатию на сегм контрол
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension TasksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksListCell")!
        cell.textLabel?.text = taskLists[indexPath.row].name
        cell.detailTextLabel?.text = String(taskLists[indexPath.row].completedTasksCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = getControllerFrom(storyboard: "Main", name: "TasksTableViewController") as! TasksTableViewController
        controller.task = taskLists[indexPath.row]
        controller.navigationItem.title = taskLists[indexPath.row].name
        pushController(viewController: controller)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = self.taskLists[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            RealmDB.deleteTaskList(taskList: taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editContextItem = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            //сделать алерт для изменения тасклиста
            RealmDB.editTaskList(taskList: taskList, name: "")
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let doneContextItem = UIContextualAction(style: .normal, title: "Done") { (_, _, _) in
            RealmDB.taskListAllDone(taskList: taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        editContextItem.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        doneContextItem.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        return swipeActions
    }
}
