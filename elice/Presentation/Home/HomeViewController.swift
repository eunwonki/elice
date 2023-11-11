//
//  HomeViewController.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import UIKit

class HomeViewController: UIViewController, StoryboardInstantiable {
    
    var reactor: HomeViewReactor!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reactor.action.onNext(.viewDidAppear)
    }

    static func create(
        with reactor: HomeViewReactor
    ) -> HomeViewController {
        let view = HomeViewController.instantiateViewController()
        view.reactor = reactor
        return view
    }

    private func bind() {
        
    }
}

