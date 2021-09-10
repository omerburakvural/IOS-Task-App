//
//  MainTableCellViewModel.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import Foundation

class CellViewModel {
    
    var task: Task?
    var reminder: Reminder?
    
    init(task: Task) {
        self.task = task
    }
    
    init(reminder:Reminder) {
        self.reminder = reminder
    }
    
    var taskTitle: String {
        task!.taskName ?? ""
    }
    var taskLogo: String {
        task!.taskLogo ?? "pencil.circle"
    }
    
    var taskColor: String{
        task?.taskColor ?? ""
    }
    
    var reminderCount: String{
        task?.reminderCount ?? "0"
    }
    
    var reminderDate: Date {
        reminder!.date!
    }

    var reminderDoneDate: Date {
        reminder!.doneDate!
    }

    var reminderScheduledDate: Date {
        reminder!.scheduledDate!
    }

    var reminderIsDone: Bool {
        reminder!.isDone
    }

    var reminderIsFlagged: Bool {
        reminder!.isFlagged
    }

    var reminderIsScheduled: Bool {
        reminder!.isScheduled
    }

    var reminderCategory: String {
        reminder!.category ?? ""
    }

    var reminderTitle: String {
        reminder!.reminderTitle ?? ""
    }
    
    var category: String {
        reminder!.category ?? ""
    }
}


