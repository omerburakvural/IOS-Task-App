//
//  StoryboardExtensions.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 30.08.2021.
//


import UIKit

extension UIStoryboard {
    
    static func createViewController (fromStoryboard storyboardName: String, forViewcontroller type: ViewControllerType) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: type.rawValue)
        
    }
    
}

enum ViewControllerType: String {
    case reminderTable = "reminderTable"
    case main = "main"
    case catPickView = "catPickView"
}
