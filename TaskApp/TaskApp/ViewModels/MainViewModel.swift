//
//  MainViewModel.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import UIKit
import CoreData

protocol MainViewModelDelegate {
    func tasksUpdated ()
}


class MainViewModel {
    
    var tasks = [Task]()
    var delegate: MainViewModelDelegate?
    var task: Task?
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do{
            if let result = try viewContext.fetch(fetchRequest) as? [Task]{
                self.tasks = result
                self.delegate?.tasksUpdated()
                return
            }
        }catch{
            print(error.localizedDescription)
        }
        
        self.tasks = []
        self.delegate?.tasksUpdated()
    }
    
    var numberOfRows: Int {
        return tasks.count
    }
    
    func getTask(atIndex index: Int) -> Task {
        return tasks[index]
    }
    
    var taskColor: String{
        task?.taskColor ?? ""
    }
    
}
