//
//  TaskDetailViewController.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 28.08.2021.
//

import UIKit
import Foundation
import CoreData
import UserNotifications

protocol ReminderEditViewDelegate {
    func reminderAdded (reminder: Reminder)
    func reminderUpdated (reminder: Reminder)
    func reminderDeleted ()
}

class ReminderEditViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate{
    
    var delegate: ReminderEditViewDelegate?
    var viewModel = ReminderEditViewModel()
    var viewModel2 = MainViewModel()
    var viewModel3 = ReminderViewModel()
    
    let today = Date()
    var scheduledDate = Date()
    
    public var completion: ((String, String, Date) -> Void)?
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var reminderNote: UITextView!
    @IBOutlet weak var isFlagged: UISwitch!
    @IBOutlet weak var isDateActive: UISwitch!
    @IBOutlet weak var isDoneSwitch: UISwitch!
    @IBOutlet weak var isDoneView: UIView!
    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var createDaeView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var thePickerView: UIPickerView!
    @IBOutlet weak var pickerViewButton: UIButton!
    @IBOutlet weak var pickedPickerTextField: UILabel!
    @IBOutlet weak var deleteReminderButton: UIButton!
    @IBOutlet weak var pickerCategoryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flagView.layer.cornerRadius=5.0
        dateView.layer.cornerRadius=5.0
        createDaeView.layer.cornerRadius=5.0
        isDoneView.layer.cornerRadius=5.0
        thePickerView.layer.cornerRadius=5.0
        deleteReminderButton.layer.cornerRadius=5.0
        pickerViewButton.layer.cornerRadius=5.0
        pickedPickerTextField.layer.cornerRadius=5.0
        pickerCategoryView.layer.cornerRadius=5.0
        reminderNote.layer.cornerRadius=5.0
        
        self.title = viewModel.title
        thePickerView.delegate = self
        thePickerView.dataSource = self
        tfTitle.text = viewModel.reminderTitile
        isFlagged.isOn = viewModel.isReminderFlagged
        isDateActive.isOn = viewModel.isScheduledFlagged
        isDoneSwitch.isOn = viewModel.isDoneFlagged
        datePicker.minimumDate = Date()
        createDateLabel.text = "Created : \(viewModel.todayDate.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"))"
        datePicker.date = viewModel.scheduledDate
        thePickerView.isHidden = true
        pickedPickerTextField.isHidden = false
        pickerViewButton.isHidden = false
        pickedPickerTextField.text = viewModel.categoryName
        reminderNote.text = viewModel.reminderNote
        
        if isDateActive.isOn{
            datePicker.isEnabled = true
        }else{
            datePicker.isEnabled = false
        }
        thePickerView.reloadAllComponents()
        
        if (self.title == "Add new Reminder"){
            deleteReminderButton.isHidden = true
        }
        
    }
    
    @IBAction func deleteReminderButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Reminder", message: "Do you want to remove the Reminder?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.viewModel.deleteReminder {
                self.dismiss(animated: true) {
                    self.delegate?.reminderDeleted()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func pickerViewButtonClicked(_ sender: Any) {
        pickerViewButton.isHidden = true
        pickedPickerTextField.isHidden = true
        thePickerView.isHidden = false
    }
    
    @IBAction func isFlagged(_ sender: Any) {
        
    }
    
    @IBAction func reminderEditCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func isDateActiveIsOn(_ sender: Any) {
        if isDateActive.isOn {
            datePicker.isEnabled = true
        }else{
            datePicker.isEnabled = false
        }
    }
    
    @IBAction func reminderEditSaveClicked(_ sender: Any) {
        let result = viewModel.saveReminder(withReminderTitle: tfTitle.text!, andFlagged: isFlagged.isOn, andScheduled: isDateActive.isOn, andDate: today, andScheduledDate: scheduledDate, andIsDoneFlagged: isDoneSwitch.isOn, andCategory: pickedPickerTextField.text!, andWithNote: reminderNote.text! )
        self.dismiss(animated: true) {
            switch (result) {
            case .added(let newreminder):
                self.delegate?.reminderAdded(reminder: newreminder)
            case .updated(let updatedReminder):
                self.delegate?.reminderUpdated(reminder: updatedReminder)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func scheduledDatePicked(_ sender: Any) {
        scheduledDate = datePicker.date
    }
    
    @IBAction func isDoneSwitchChanged(_ sender: Any) {
        if isDoneSwitch.isOn {
            datePicker.isEnabled = false
            reminderNote.isEditable = false
            isFlagged.isEnabled = false
            isDateActive.isEnabled = false
            datePicker.isEnabled = false
            pickerViewButton.isEnabled = false
            tfTitle.isEnabled = false
        }else{
            datePicker.isEnabled = true
            reminderNote.isEditable = true
            isFlagged.isEnabled = true
            isDateActive.isEnabled = true
            datePicker.isEnabled = true
            pickerViewButton.isEnabled = true
            tfTitle.isEnabled = true
        }
    }
    
    func comingFromNotification(withTitle: String){
        for i in 0..<viewModel3.numberOfRows{
            if(viewModel3.getReminders(atIndex: i).reminderTitle == withTitle){
                viewModel.reminder = viewModel3.getReminders(atIndex: i)
            }
        }
    }
    
}

extension ReminderEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel2.numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickedPickerTextField.isHidden = false
        self.thePickerView.isHidden = true
        pickerViewButton.isHidden = false
        self.pickedPickerTextField.text = viewModel2.getTask(atIndex: row).taskName
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel2.getTask(atIndex: row).taskName
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
