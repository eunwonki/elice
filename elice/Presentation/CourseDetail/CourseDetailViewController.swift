//
//  CourseDetailViewController.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import UIKit

class CourseDetailViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet var tableView: UITableView!
    
    static func create() -> CourseDetailViewController {
        CourseDetailViewController.instantiateViewController()
    }
    
    @IBAction func backButtonTouchUp() {
        self.navigationController?.popViewController(animated: true)
    }
}
