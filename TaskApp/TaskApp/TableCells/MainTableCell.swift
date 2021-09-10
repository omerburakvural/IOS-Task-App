//
//  MainTableCell.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import UIKit

protocol MaintableCellDelegate {
    func taskCompleted (task: Task)
}

class MainTableCell: UITableViewCell {
    
    @IBOutlet weak var mainTaskTitle: UILabel!
    @IBOutlet weak var mainTaskLogo: UIImageView!
    @IBOutlet weak var mainTaskReminderCount: UILabel!
    
    var delegate: MaintableCellDelegate?
    var taskColor: UIColor! = UIColor.systemBlue
    
    var viewModel: CellViewModel! {
        didSet {
            let config = UIImage.SymbolConfiguration(textStyle: .largeTitle)
            mainTaskLogo.image = UIImage(systemName: viewModel.taskLogo, withConfiguration: config)
            mainTaskTitle.text = viewModel.taskTitle
            
            if (viewModel.taskColor == "orange"){
                taskColor = UIColor.systemOrange
            }else if(viewModel.taskColor == "cyan blue"){
                taskColor = UIColor.systemBlue
            }else if(viewModel.taskColor == "red"){
                taskColor = UIColor.systemRed
            }else if(viewModel.taskColor == "green"){
                taskColor = UIColor.systemGreen
            }else if(viewModel.taskColor == "purple"){
                taskColor = UIColor.systemPurple
            }else{
                taskColor = UIColor.systemBlue
            }
            mainTaskLogo.tintColor = taskColor
            mainTaskTitle.textColor = taskColor
        }
    }
}
