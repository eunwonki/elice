//
//  HomeViewController.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import UIKit

class HomeViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet var tableView: UITableView!
    var reactor: HomeViewReactor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reactor.action.onNext(.viewDidLoad)
    }
    
    static func create(
        with reactor: HomeViewReactor
    ) -> HomeViewController {
        let view = HomeViewController.instantiateViewController()
        view.reactor = reactor
        return view
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 292
    }
    
    private func sortedInHomeView() -> [CourseListQuery] {
        return [.free, .recommend, .registered]
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView, 
        numberOfRowsInSection section: Int
    ) -> Int {
        return CourseListQuery.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CourseListCell.reuseIdentifier,
            for: indexPath
        ) as? CourseListCell else {
            return UITableViewCell()
        }
        
        let allCases = sortedInHomeView()
        
        switch allCases[indexPath.row] {
        case .free: 
            cell.titleLabel.text = "무료 과목"
            cell.bind(with: reactor.freeListReactor)
        case .recommend:
            cell.titleLabel.text = "추천 과목"
            cell.bind(with: reactor.recommendListReactor)
        case .registered:
            cell.titleLabel.text = "내 학습"
            cell.bind(with: reactor.registeredListReactor)
        }
        
        return cell
    }
}

