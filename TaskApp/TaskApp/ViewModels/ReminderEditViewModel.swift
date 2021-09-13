//
//  DetailTableCellViewModel.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import UIKit
import CoreData

enum ReminderSaveResults {
    case added (Reminder)
    case updated (Reminder)
    case error (Error)
}

class ReminderEditViewModel {
    
    var reminder: Reminder?
    var wasIsDoneActive = false
    
    init (reminder: Reminder? = nil){
        self.reminder = reminder
    }
    
    var title: String {
        reminder == nil ? "Add new Reminder" : "Update Reminder"
    }
    
    var reminderTitile: String{
        reminder?.reminderTitle ?? ""
    }
    
    var isReminderFlagged: Bool{
        reminder?.isFlagged ?? false
    }
    
    var isScheduledFlagged: Bool{
        reminder?.isScheduled ?? false
    }
    
    var isDoneFlagged: Bool{
        reminder?.isDone ?? false
    }
    
    var todayDate: Date{
        reminder?.date ?? Date()
    }
    
    var scheduledDate: Date{
        reminder?.scheduledDate ?? Date()
    }
    
    var categoryName: String{
        reminder?.category ?? ""
    }
    
    var reminderNote: String{
        reminder?.note ?? ""
    }
    
    func saveReminder (withReminderTitle reminderTitle: String, andFlagged isFlagged: Bool, andScheduled isScheduled: Bool, andDate today: Date, andScheduledDate scheduledDate: Date, andIsDoneFlagged isDoneSwitch: Bool, andCategory categoryName: String, andWithNote: String) -> ReminderSaveResults {
        
        var isNewReminder = false
        
        
        if title == "Add new Reminder"{
            isNewReminder = true
            reminder = Reminder(context: viewContext)
            reminder!.date = today
        }
        
        reminder?.reminderTitle = reminderTitle
        reminder!.isFlagged = isFlagged
        reminder!.isScheduled = isScheduled
        reminder!.scheduledDate = scheduledDate
        reminder!.isDone = isDoneSwitch
        reminder?.category = categoryName
        reminder?.note = andWithNote
        
        let content = UNMutableNotificationContent()
        content.title = reminderTitle
        content.sound = .default
        content.body = scheduledDate.toString(dateFormat: "dd/MM/YYYY HH:mm")
        //content.userInfo
        
        let targetDate = scheduledDate
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: reminderTitle, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        
        do {
            try viewContext.save()
            
            if isNewReminder {
                return .added(reminder!)
            } else {
                return .updated(reminder!)
            }
            
        } catch {
            return .error(error)
        }
    }
    
    func deleteReminder (completion: () -> Void) {
        if reminder != nil {
            viewContext.delete(reminder!)
            do {
                try viewContext.save()
                completion()
            } catch {}
        }
    }
    
}
