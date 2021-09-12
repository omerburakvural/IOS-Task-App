//
//  DetailTableCell.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import UIKit

protocol ReminderTableCellDelegate {
    func reminderCompleted (reminder: Reminder)
}

class ReminderTableCell: UITableViewCell {
    var delegate: ReminderTableCellDelegate?
    
    @IBOutlet weak var reminderCellTitle: UILabel!
    
    var viewModel: CellViewModel! {
        didSet {
            reminderCellTitle.text = viewModel.reminderTitle
        }
    }
    
}

