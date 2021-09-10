//
//  ReminderViewController.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import UIKit


protocol ReminderTableViewControllerDelegate {
    func getReminderTableTitle() -> String
    func reloadReminderTable()
}

class ReminderTableViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var reminderTableView: UITableView!
    
    var viewModel = ReminderViewModel()
    var isRowHidden  : Bool = false
    
    var filteredReminders: [Reminder] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderTableView.dataSource = self
        reminderTableView.delegate = self
        viewModel.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a reminder.."
        navigationItem.searchController = searchController
        definesPresentationContext = true

        if isFiltering{
            self.title = "Search Results"
        }
        
        reminderTableView.reloadData()
    }
    
    @IBAction func backToTheMainViewButton(_ sender: Any) {
        if let vc = UIStoryboard.createViewController(fromStoryboard: "Main", forViewcontroller: .main) as? MainViewController {
            self.navigationController?.replaceCurrentView(withViewController: vc)
        }
    }
    
    @IBAction func addReminderButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "reminderEdit") as? ReminderEditViewController {
            vc.viewModel = ReminderEditViewModel(reminder: nil)
            vc.delegate = ReminderEditViewController() as? ReminderEditViewDelegate
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func openReminderDetail (forReminder reminder: Reminder? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "reminderEdit") as? ReminderEditViewController {
            vc.viewModel = ReminderEditViewModel(reminder: reminder)
            vc.delegate = self
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func getReminderTableTitle() -> String{
        return self.title ?? ""
    }
    
    func reloadReminderTable(){
        reminderTableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredReminders = viewModel.reminders.filter { (reminder: Reminder) -> Bool in
            return (reminder.reminderTitle?.lowercased().contains(searchText.lowercased()))!
      }
      reminderTableView.reloadData()
    }
}

extension ReminderTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        self.searchController.searchBar.delegate = self
    }
}

extension ReminderTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredReminders.count
        }
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reminder = viewModel.getReminders(atIndex: indexPath.item)
        
        if(isFiltering){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                let reminder: Reminder
                reminder = filteredReminders[indexPath.row]
                cell.delegate = self
                cell.viewModel = CellViewModel(reminder: reminder)
                return cell
            }
        }
        
        if (self.title == "Flagged Reminders"){
            isRowHidden = false
            if (reminder.isFlagged){
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                    if (reminder.isDone){
                        cell.reminderCellTitle.textColor = UIColor.systemGray
                    }else{
                        cell.reminderCellTitle.textColor = UIColor.label
                    }
                    cell.delegate = self
                    cell.viewModel = CellViewModel(reminder: reminder)
                    return cell
                }
            }else{
                isRowHidden = true
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                    cell.delegate = self
                    cell.viewModel = CellViewModel(reminder: reminder)
                    return cell
                }
            }
        }
        
        if (self.title == "Scheduled Reminders"){
            isRowHidden = false
            if (reminder.isScheduled){
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                    if (reminder.isDone){
                    cell.reminderCellTitle.textColor = UIColor.systemGray
                    }else{
                        cell.reminderCellTitle.textColor = UIColor.label
                    }
                    cell.delegate = self
                    cell.viewModel = CellViewModel(reminder: reminder)
                    return cell
                }
            }else{
                isRowHidden = true
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                    cell.delegate = self
                    cell.viewModel = CellViewModel(reminder: reminder)
                    return cell
                }
            }
        }
        
        if (self.title == "Today"){
            isRowHidden = false
            if ((Date().toString(dateFormat: "yyyy-MM-dd")) == reminder.scheduledDate?.toString(dateFormat: "yyyy-MM-dd") && reminder.isScheduled){
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                    if (reminder.isDone){
                        cell.reminderCellTitle.textColor = UIColor.systemGray
                    }else{
                        cell.reminderCellTitle.textColor = UIColor.label
                    }
                    cell.delegate = self
                    cell.viewModel = CellViewModel(reminder: reminder)
                    return cell
                }
            }else{
                isRowHidden = true
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                    cell.delegate = self
                    cell.viewModel = CellViewModel(reminder: reminder)
                    return cell
                }
            }
        }
        
        if (self.title == "All Reminders"){ //All reminders
            isRowHidden = false
            if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                if (reminder.isDone){
                cell.reminderCellTitle.textColor = UIColor.systemGray
                }else{
                    cell.reminderCellTitle.textColor = UIColor.label
                }

                cell.delegate = self
                cell.viewModel = CellViewModel(reminder: reminder)
                return cell
            }
        }
        
        if (self.title == reminder.category){
            isRowHidden = false
            if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell") as? ReminderTableCell {
                if (reminder.isDone){
                cell.reminderCellTitle.textColor = UIColor.systemGray
                }else{
                    cell.reminderCellTitle.textColor = UIColor.label
                }
                cell.delegate = self
                cell.viewModel = CellViewModel(reminder: reminder)
                return cell
            }
        }else{
            isRowHidden = true
        }
        reminderTableView.reloadRows(at: [indexPath], with: .none)
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 44.0
        if (isRowHidden) {
            height = 0.0
        } else {
            height = 44.0
        }
        return height
    }
}

extension ReminderTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openReminderDetail(forReminder: viewModel.getReminders(atIndex: indexPath.item))
    }
    
}

extension ReminderTableViewController: ReminderEditViewDelegate {
    func reminderDeleted() {
        viewModel.loadReminders()
    }
    
    func reminderAdded(reminder: Reminder) {
        viewModel.loadReminders()
    }
    
    func reminderUpdated(reminder: Reminder) {
        viewModel.loadReminders()
    }
}

extension ReminderTableViewController: ReminderViewModelDelegate {
    func filterTableCells() {
        reminderTableView.reloadData()
    }
    
    func remindersUpdated() {
        reminderTableView.reloadData()
    }
}

extension ReminderTableViewController: ReminderTableCellDelegate {
    func reminderCompleted(reminder: Reminder) {
        viewModel.loadReminders()
    }
}
