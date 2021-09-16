//
//  T.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import UIKit
import CoreData

protocol ReminderTableViewModelDelegate {
    func remindersUpdated ()
}

class ReminderTableViewModel {
    
    var reminders = [Reminder]()
    var reminder: Reminder?
    var delegate: ReminderTableViewModelDelegate?
    
    init() {
        loadReminders()
    }
    
    func loadReminders() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        
        do{
            if let result = try viewContext.fetch(fetchRequest) as? [Reminder]{
                self.reminders = result
                self.delegate?.remindersUpdated()
                return
            }
        }catch{
            print(error.localizedDescription)
        }
        
        self.reminders = []
        self.delegate?.remindersUpdated()
    }
    
    var numberOfRows: Int {
        reminders.count
    }
    
    func getReminders(atIndex index: Int) -> Reminder {
        reminders[index]
    }
    
    func setReminderCategory(atIndex: Int,category: String){
        reminders[atIndex].category = category
    }
    
    func getReminderID(atIndex index: Int) -> ObjectIdentifier {
        reminders[index].id
    }
    
    func getReminderCount(taskNameTitle: String) -> String{
        var count = 0
        
        for i in 0..<reminders.count{
            if (reminders[i].category == taskNameTitle){
                count += 1
            }
        }
        return "\(count)"
    }
}
