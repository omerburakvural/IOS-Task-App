//
//  NavigationControllerExtensions.swift
//  TaskApp
//
//  Created by Omer Burak Vural on 30.08.2021.
//

import UIKit

extension UINavigationController {
    
    func replaceCurrentView (withViewController vc: UIViewController) {
        self.viewControllers.append(vc)
        self.viewControllers.remove(at: 0)
    }
}
