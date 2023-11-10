//
//  HomeViewController.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import UIKit

class HomeViewController: UIViewController, StoryboardInstantiable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    static func create() -> HomeViewController {
        HomeViewController.instantiateViewController()
    }

}

