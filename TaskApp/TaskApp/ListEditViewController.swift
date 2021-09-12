//
//  ListEditViewController.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 29.08.2021.
//

import UIKit

protocol ListEditViewDelegate {
    func taskAdded (task: Task)
    func taskUpdated (task: Task)
    func taskDeleted ()
}

class ListEditViewController: UIViewController {
    
    @IBOutlet var listEditView: UIView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var colourButton1: UIButton!
    @IBOutlet weak var colourButton2: UIButton!
    @IBOutlet weak var colourButton3: UIButton!
    @IBOutlet weak var colourButton4: UIButton!
    @IBOutlet weak var colourButton5: UIButton!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton4: UIButton!
    @IBOutlet weak var imageButton5: UIButton!
    @IBOutlet weak var imageButton6: UIButton!
    @IBOutlet weak var imageButton7: UIButton!
    @IBOutlet weak var imageButton8: UIButton!
    @IBOutlet weak var imageButton9: UIButton!
    @IBOutlet weak var imageButton10: UIButton!
    @IBOutlet weak var imageButton11: UIButton!
    @IBOutlet weak var imageButton12: UIButton!
    @IBOutlet weak var imageButton13: UIButton!
    @IBOutlet weak var imageButton14: UIButton!
    @IBOutlet weak var imageButton15: UIButton!
    @IBOutlet weak var imageButton16: UIButton!
    @IBOutlet weak var imageButton17: UIButton!
    @IBOutlet weak var imageButton18: UIButton!
    @IBOutlet weak var imageButton19: UIButton!
    @IBOutlet weak var imageButton20: UIButton!
    @IBOutlet weak var imageButton21: UIButton!
    @IBOutlet weak var imageButton22: UIButton!
    @IBOutlet weak var imageButton23: UIButton!
    @IBOutlet weak var imageButton24: UIButton!
    @IBOutlet weak var taskdeleteButton: UIButton!
    
    var delegate: ListEditViewDelegate?
    var viewModel: ListEditViewModel!
    
    var taskColour: UIColor! = UIColor.systemBlue
    var taskSymbol: String = "pencil.circle"
    var reminderCount: String = "0"
    
    var imageButtonArray: [UIButton] = []
    var colorButtonArray: [UIButton] = []
    
    func setupButtonStyle(button : UIButton, color: UIColor){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = color
    }
    
    func setupButtonStyle(button : UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        taskdeleteButton.layer.cornerRadius = 5.0
        tfTitle.text = viewModel.taskTitile
        colorButtonArray = [colourButton1,colourButton2,colourButton3,colourButton4,colourButton5]
        imageButtonArray = [imageButton1,imageButton2,imageButton3,imageButton4,imageButton5,imageButton6,imageButton7,imageButton8,imageButton9,imageButton10,imageButton11,imageButton12,imageButton13,imageButton14,imageButton15,imageButton16,imageButton17,imageButton18,imageButton19,imageButton20,imageButton21,imageButton22,imageButton23,imageButton24];
        setupButtonStyle(button: colourButton1, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        setupButtonStyle(button: colourButton2, color: #colorLiteral(red: 0.364551723, green: 0.662788868, blue: 0.8665581346, alpha: 1))
        setupButtonStyle(button: colourButton3, color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        setupButtonStyle(button: colourButton4, color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        setupButtonStyle(button: colourButton5, color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        taskSymbol = viewModel.taskLogo
        
        if (viewModel.taskColor == "orange"){
            taskColour = UIColor.systemOrange
        }else if(viewModel.taskColor == "cyan blue"){
            taskColour = UIColor.systemBlue
        }else if(viewModel.taskColor == "red"){
            taskColour = UIColor.systemRed
        }else if(viewModel.taskColor == "green"){
            taskColour = UIColor.systemGreen
        }else if(viewModel.taskColor == "purple"){
            taskColour = UIColor.systemPurple
        }else{
            taskColour = UIColor.systemBlue
        }
        
        navigationController?.navigationBar.tintColor = taskColour
        view.tintColor = taskColour
        
        if (viewModel.taskLogo != ""){
            for i in 0..<imageButtonArray.count{
                if viewModel.taskLogo == imageButtonArray[i].accessibilityLabel {
                    imageButtonArray[i].backgroundColor = UIColor.opaqueSeparator
                }
            }
        }
        
        for i in 0..<imageButtonArray.count{
            setupButtonStyle(button: imageButtonArray[i])
        }
        
        if (self.title == "Add new Task"){
            taskdeleteButton.isHidden = true
        }
    }
    
    @IBAction func taskDeleteButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Task", message: "Do you want to remove the Task?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.viewModel.deleteTask {
                self.dismiss(animated: true) {
                    self.delegate?.taskDeleted()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func colorButtonClicked(_ sender: UIButton) {
        let senderTag = sender.tag
        
        switch senderTag {
        case 1:
            navigationController?.navigationBar.tintColor = UIColor.systemOrange
            view.tintColor = UIColor.systemOrange
            taskColour = UIColor.systemOrange
        case 2:
            navigationController?.navigationBar.tintColor = UIColor.systemBlue
            view.tintColor = UIColor.systemBlue
            taskColour = UIColor.systemBlue
        case 3:
            navigationController?.navigationBar.tintColor = UIColor.systemRed
            view.tintColor = UIColor.systemRed
            taskColour = UIColor.systemRed
        case 4:
            navigationController?.navigationBar.tintColor = UIColor.systemGreen
            view.tintColor = UIColor.systemGreen
            taskColour = UIColor.systemGreen
        case 5:
            navigationController?.navigationBar.tintColor = UIColor.systemPurple
            view.tintColor = UIColor.systemPurple
            taskColour = UIColor.systemPurple
        default:
            navigationController?.navigationBar.tintColor = UIColor.systemBlue
            view.tintColor = UIColor.systemBlue
            taskColour = UIColor.systemBlue
        }
        
    }
    
    @IBAction func iconButtonClicked(_ sender: UIButton) {
        let senderTag = sender.tag
        var color = UIColor.systemBackground
        
        for i in 0..<imageButtonArray.count{
            imageButtonArray[i].backgroundColor = color
        }
        
        color = UIColor.opaqueSeparator
        
        switch senderTag {
        case 1:
            imageButton1.backgroundColor = color
            taskSymbol = imageButton1.accessibilityLabel!
        case 2:
            imageButton2.backgroundColor = color
            taskSymbol = imageButton2.accessibilityLabel!
        case 3:
            imageButton3.backgroundColor = color
            taskSymbol = imageButton3.accessibilityLabel!
        case 4:
            imageButton4.backgroundColor = color
            taskSymbol = imageButton4.accessibilityLabel!
        case 5:
            imageButton5.backgroundColor = color
            taskSymbol = imageButton5.accessibilityLabel!
        case 6:
            imageButton6.backgroundColor = color
            taskSymbol = imageButton6.accessibilityLabel!
        case 7:
            imageButton7.backgroundColor = color
            taskSymbol = imageButton7.accessibilityLabel!
        case 8:
            imageButton8.backgroundColor = color
            taskSymbol = imageButton8.accessibilityLabel!
        case 9:
            imageButton9.backgroundColor = color
            taskSymbol = imageButton9.accessibilityLabel!
        case 10:
            imageButton10.backgroundColor = color
            taskSymbol = imageButton10.accessibilityLabel!
        case 11:
            imageButton11.backgroundColor = color
            taskSymbol = imageButton11.accessibilityLabel!
        case 12:
            imageButton12.backgroundColor = color
            taskSymbol = imageButton12.accessibilityLabel!
        case 13:
            imageButton13.backgroundColor = color
            taskSymbol = imageButton13.accessibilityLabel!
        case 14:
            imageButton14.backgroundColor = color
            taskSymbol = imageButton14.accessibilityLabel!
        case 15:
            imageButton15.backgroundColor = color
            taskSymbol = imageButton15.accessibilityLabel!
        case 16:
            imageButton16.backgroundColor = color
            taskSymbol = imageButton16.accessibilityLabel!
        case 17:
            imageButton17.backgroundColor = color
            taskSymbol = imageButton17.accessibilityLabel!
        case 18:
            imageButton18.backgroundColor = color
            taskSymbol = imageButton18.accessibilityLabel!
        case 19:
            imageButton19.backgroundColor = color
            taskSymbol = imageButton19.accessibilityLabel!
        case 20:
            imageButton20.backgroundColor = color
            taskSymbol = imageButton20.accessibilityLabel!
        case 21:
            imageButton21.backgroundColor = color
            taskSymbol = imageButton21.accessibilityLabel!
        case 22:
            imageButton22.backgroundColor = color
            taskSymbol = imageButton22.accessibilityLabel!
        case 23:
            imageButton23.backgroundColor = color
            taskSymbol = imageButton23.accessibilityLabel!
        case 24:
            imageButton24.backgroundColor = color
            taskSymbol = imageButton24.accessibilityLabel!
        default:
            imageButton1.backgroundColor = color
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let result = viewModel.saveTask(withTaskTitle: tfTitle.text, andWithTaskLogo: taskSymbol, anWithTaskColor: taskColour.accessibilityName, andWithReminderCount: reminderCount)
        self.dismiss(animated: true) {
            switch (result) {
            case .added(let newtask):
                self.delegate?.taskAdded(task: newtask)
            case .updated(let updatedTask):
                self.delegate?.taskUpdated(task: updatedTask)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
