//
//  TaskListViewModel.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import Foundation


enum TaskSaveResults {
    case added (Task)
    case updated (Task)
    case error (Error)
}

class ListEditViewModel {
    
    var viewModel = ReminderViewModel()
    var task: Task?
    
    init (task: Task? = nil){
        self.task = task
    }
    
    var title: String {
        task == nil ? "Add new Task" : "Update Task"
    }
    
    var taskTitile: String{
        task?.taskName ?? ""
    }
    
    var taskLogo: String{
        task?.taskLogo ?? "pencil.circle"
    }
    
    var taskColor: String{
        task?.taskColor ?? ""
    }
    
    var taskId: Int32{
        task!.taskId
    }
    
    func saveTask (withTaskTitle taskTitle: String?, andWithTaskLogo taskLogo: String?, anWithTaskColor taskColor: String?, andWithReminderCount reminderCount: String?) -> TaskSaveResults {
        
        var isNewTask = false
        
        if title == "Add new Task"{
            isNewTask = true
            task = Task(context: viewContext)
        }
        task?.taskName = taskTitle
        task?.taskLogo = taskLogo
        task?.taskColor = taskColor
        task?.reminderCount = reminderCount!

        do {
            try viewContext.save()
            
            if isNewTask {
                return .added(task!)
            } else {
                return .updated(task!)
            }
            
        } catch {
            return .error(error)
        }
        
    }
    
    func deleteTask (completion: () -> Void) {
        for i in 0..<viewModel.numberOfRows{
            if (self.taskTitile == (viewModel.getReminders(atIndex: i).category)!){
                viewModel.getReminders(atIndex: i).category = ""
            }
        }
        
        if task != nil {
            viewContext.delete(task!)
            do {
                try viewContext.save()
                completion()
            } catch {}
        }
    }

}
