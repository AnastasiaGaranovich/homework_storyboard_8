import UIKit

class TasksListViewController: UIViewController {
    @IBOutlet weak var filterTasksListControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addTasksListButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Tasks List", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Enter tasks list's name"
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            let textField = alert.textFields!.first!
            RealmDB.addTasksList(tasksList: TaskList(name: textField.text ?? "No name"))
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

extension TasksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksListCell")!
        return cell
    }
    
    
}
