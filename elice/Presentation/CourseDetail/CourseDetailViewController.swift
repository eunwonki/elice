//
//  CourseDetailViewController.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import MarkdownView
import UIKit
import RxSwift
import RxDataSources
import RxGesture

class CourseDetailViewController: UIViewController, StoryboardInstantiable {
    class SingleSection {
        typealias LectureSectionModel = SectionModel<Int, LectureItem>
        
        enum LectureItem: Equatable {
            case firstItem(Lecture)
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var titleWithImageView: UIView!
    @IBOutlet weak var titleWithoutImageView: UIView!
    
    @IBOutlet weak var descriptionTitleView: UIView!
    lazy var descriptionView = MarkdownView()
    @IBOutlet weak var lecturesTitleView: UIView!
    @IBOutlet weak var lectureTableView: UITableView!
    @IBOutlet weak var lectureTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var spaceView: UIView!
    
    @IBOutlet weak var registerButton: UILabel!
    
    @IBOutlet weak var titleWithImage: UILabel!
    @IBOutlet weak var logoWithImage: UIImageView!
    @IBOutlet weak var imageWithImage: UIImageView!
    
    @IBOutlet weak var titleWithoutImage: UILabel!
    @IBOutlet weak var shortDescriptionWithoutImage: UILabel!
    @IBOutlet weak var logoWithoutImage: UIImageView!
    
    var reactor: CourseDetailViewReactor!
    var disposeBag = DisposeBag()
    
    static func create(
        with reactor: CourseDetailViewReactor
    ) -> CourseDetailViewController {
        let view = CourseDetailViewController.instantiateViewController()
        view.reactor = reactor
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        reactor.action.onNext(.viewDidLoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func backButtonTouchUp() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupStackView(_ course: Course) {
        if let image = course.image,
           image.isEmpty == false {
            titleWithoutImageView.removeFromSuperview()
            stackView.addArrangedSubview(titleWithImageView)
            
            titleWithImage.text = course.title
            if let logo = course.logo, logo.isEmpty == false {
                logoWithImage.kf.setImage(with: URL(string: logo))
            }
            imageWithImage.kf.setImage(with: URL(string: image))
        } else {
            titleWithImageView.removeFromSuperview()
            stackView.addArrangedSubview(titleWithoutImageView)
            
            titleWithoutImage.text = course.title
            shortDescriptionWithoutImage.text = course.shortDescription ?? ""
            if let logo = course.logo, logo.isEmpty == false {
                logoWithoutImage.kf.setImage(with: URL(string: logo))
            }
        }
        
        if let description = course.description,
           description.isEmpty == false {
            stackView.addArrangedSubview(descriptionTitleView)
            stackView.addArrangedSubview(descriptionView)
            descriptionTitleView.isHidden = false
            descriptionView.isHidden = false
            descriptionView.isScrollEnabled = false
            descriptionView.load(markdown: course.description)
        } else {
            descriptionTitleView.isHidden = true
            descriptionView.isHidden = true
        }
        
        stackView.addArrangedSubview(lecturesTitleView)
        stackView.addArrangedSubview(lectureTableView)
        stackView.addArrangedSubview(spaceView)
    }
    
    private func bind() {
        registerButton.rx.tapGesture()
            .when(.recognized)
            .compactMap { [weak self] _ in
                self?.reactor.currentState.isRegistered
            }.map {
                let query: CourseRegisterQuery = $0 ? .unregister : .register
                return .didRegisterClicked(query: query)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SingleSection.LectureSectionModel> {
            [weak self] dataSource, tableView, indexPath, item in
            guard let self else { return UITableViewCell() }
            
            switch item {
            case .firstItem(let lecture):
                guard let cell = self.lectureTableView.dequeueReusableCell(
                    withIdentifier: LectureCell.reuseIdentifier,
                    for: indexPath
                ) as? LectureCell else {
                    print(lecture)
                    return UITableViewCell()
                }
                
                cell.bind(lecture)
                cell.lineToNext.isHidden = false
                
                if indexPath.row == reactor.currentState.lectureOffset - 1 {
                    cell.lineToNext.isHidden = true
                    reactor.action.onNext(.loadMoreLectures)
                }
                
                return cell
            }
        }
        
        reactor.state.compactMap(\.course)
            .distinctUntilChanged()
            .bind(onNext: setupStackView)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.lectureSection)
            .distinctUntilChanged()
            .map(Array.init(with:))
            .bind(to: lectureTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map(\.lectureSection)
            .distinctUntilChanged()
            .map { CGFloat($0.items.count) }
            .bind(onNext: { [weak self] count in
                self?.lectureTableView.isHidden = count == 0
                self?.lecturesTitleView.isHidden = count == 0
                
                self?.lectureTableViewHeight.constant = count * LectureCell.height
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isRegistered)
            .distinctUntilChanged()
            .bind { [weak self] registered in
                self?.registerButton.isHidden = registered == nil
                guard let registered else { return }
                  
                self?.registerButton.backgroundColor = registered ?
                UIColor(resource: .red01) : UIColor(resource: .blue01)
                self?.registerButton.text = registered ?
                "수강 취소" : "수강 신청"
                
                self?.view.setNeedsLayout()
            }
            .disposed(by: disposeBag)
    }
}
