//
//  ViewController.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 24.08.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var scheduledView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var flaggedView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var todayButtonCount: UILabel!
    @IBOutlet weak var scheduledButtonCount: UILabel!
    @IBOutlet weak var allButtonCount: UILabel!
    @IBOutlet weak var flaggedButtonCount: UILabel!
    @IBOutlet weak var bottomNewTaskButton: UIBarButtonItem!
    
    
    
    var viewModel = MainViewModel()
    var viewModel2 = ReminderViewModel()
    
    override func viewDidLoad() {
        self.title = "TaskApp"
        super.viewDidLoad()
        todayView.layer.cornerRadius=10.0
        scheduledView.layer.cornerRadius=10.0
        allView.layer.cornerRadius=10.0
        flaggedView.layer.cornerRadius=10.0
        mainTableView.dataSource = self
        mainTableView.delegate = self
        viewModel.delegate = self
        todayButtonCount.text =  reminderFilter(withIdentifier: "todayButtonCount")
        scheduledButtonCount.text =  reminderFilter(withIdentifier: "scheduledButtonCount")
        allButtonCount.text = reminderFilter(withIdentifier: "allButtonCount")
        flaggedButtonCount.text = reminderFilter(withIdentifier: "flaggedButtonCount")
    }

    @IBAction func todayButtonClicked(_ sender: Any) {
        if let vc = UIStoryboard.createViewController(fromStoryboard: "Main", forViewcontroller: .reminderTable) as? ReminderTableViewController {
            vc.title = "Today"
            vc.viewModel = ReminderViewModel()
            self.navigationController?.replaceCurrentView(withViewController: vc)
        }
    }
    
    @IBAction func scheduledButtonClicked(_ sender: Any) {
        if let vc = UIStoryboard.createViewController(fromStoryboard: "Main", forViewcontroller: .reminderTable) as? ReminderTableViewController {
            vc.title = "Scheduled Reminders"
            vc.viewModel = ReminderViewModel()
            self.navigationController?.replaceCurrentView(withViewController: vc)
        }
    }
    
    @IBAction func allButtonClicked(_ sender: Any) {
        if let vc = UIStoryboard.createViewController(fromStoryboard: "Main", forViewcontroller: .reminderTable) as? ReminderTableViewController {
            vc.title = "All Reminders"
            vc.viewModel = ReminderViewModel()
            self.navigationController?.replaceCurrentView(withViewController: vc)
        }
    }
    
    @IBAction func flaggedButtonClicked(_ sender: Any) {
        if let vc = UIStoryboard.createViewController(fromStoryboard: "Main", forViewcontroller: .reminderTable) as? ReminderTableViewController {
            vc.title = "Flagged Reminders"
            vc.viewModel = ReminderViewModel()
            self.navigationController?.replaceCurrentView(withViewController: vc)
        }
    }
    
    @IBAction func newReminderClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "reminderEdit") as? ReminderEditViewController {
            vc.viewModel = ReminderEditViewModel(reminder: nil)
            vc.delegate = ReminderEditViewController() as? ReminderEditViewDelegate
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func newTaskClicked(_ sender: Any) {
        openTaskDetail()
    }
    
    private func openTaskDetail (forTask task: Task? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "listEdit") as? ListEditViewController {
            vc.viewModel = ListEditViewModel(task: task)
            vc.delegate = self
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func reminderFilter(withIdentifier: String) -> String{
        var flaggedCount = 0
        var scheduledCount = 0
        var todayCount = 0
        var totalCount = 0
        var reminderCount = 0
        
        for i in 0..<viewModel2.numberOfRows{
            let index = viewModel2.getReminders(atIndex: i)
            
            if (index.isFlagged){
                if (index.isScheduled){
                   if ((Date().toString(dateFormat: "yyyy-MM-dd")) == (index.scheduledDate?.toString(dateFormat: "yyyy-MM-dd"))){
                    todayCount = todayCount + 1
                    }
                    scheduledCount += 1
                }
                flaggedCount += 1
                totalCount += 1
               
            }else if (index.isScheduled){
                if ((Date().toString(dateFormat: "yyyy-MM-dd")) == (index.scheduledDate?.toString(dateFormat: "yyyy-MM-dd"))){
                    todayCount = todayCount + 1
                }
                scheduledCount += 1
                totalCount += 1
                
            }else if (index.category == viewModel.task?.taskName) {
                reminderCount += 1
                totalCount += 1
            }else {
                totalCount += 1
            }
        }
        
        switch withIdentifier {
        case "todayButtonCount":
            return "\(todayCount)"
        case "scheduledButtonCount":
            return "\(scheduledCount)"
        case "flaggedButtonCount":
            return "\(flaggedCount)"
        case viewModel.task?.taskName:
            return "\(reminderCount)"
        default:
            return "\(totalCount)"
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = viewModel.getTask(atIndex: indexPath.item)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? MainTableCell {

            cell.mainTaskReminderCount.text = viewModel2.getReminderCount(taskNameTitle: viewModel.getTask(atIndex: indexPath.item).taskName!)
            cell.delegate = self
            cell.viewModel = CellViewModel(task: task)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.createViewController(fromStoryboard: "Main", forViewcontroller: .reminderTable) as? ReminderTableViewController {
            vc.title = self.viewModel.getTask(atIndex: indexPath.item).taskName
            self.navigationController?.replaceCurrentView(withViewController: vc)
        }
    
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit"){(_,_, MTLNewLibraryCompletionHandler) in
            self.openTaskDetail(forTask: self.viewModel.getTask(atIndex: indexPath.item))
        }
        editAction.backgroundColor = .systemBlue
        let action = UISwipeActionsConfiguration(actions: [editAction])
        return action
    }
}

extension MainViewController: ListEditViewDelegate {
    
    func taskDeleted() {
        viewModel.loadTasks()
    }
    
    func taskAdded(task: Task) {
        viewModel.loadTasks()
    }
    
    func taskUpdated(task: Task) {
        viewModel.loadTasks()
    }
}

extension MainViewController: MainViewModelDelegate {
    func tasksUpdated() {
        mainTableView.reloadData()
    }
}

extension MainViewController: MaintableCellDelegate {
    func taskCompleted(task: Task) {
        viewModel.loadTasks()
    }
}
