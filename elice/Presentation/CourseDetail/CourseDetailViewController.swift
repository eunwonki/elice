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

class CourseDetailViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var titleWithImageView: UIView!
    @IBOutlet weak var titleWithoutImageView: UIView!
    
    @IBOutlet weak var descriptionTitleView: UIView!
    lazy var descriptionView = MarkdownView()
    @IBOutlet weak var lecturesTitleView: UIView!
    @IBOutlet weak var spaceView: UIView!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerButtonLabel: UILabel!
    
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
        if let image = course.image {
            titleWithoutImageView.removeFromSuperview()
            stackView.addArrangedSubview(titleWithImageView)
            
            titleWithImage.text = course.title
            logoWithImage.kf.setImage(with: URL(string: course.logo ?? ""))
            imageWithImage.kf.setImage(with: URL(string: course.image ?? ""))
        } else {
            titleWithImageView.removeFromSuperview()
            stackView.addArrangedSubview(titleWithoutImageView)
            
            titleWithoutImage.text = course.title
            shortDescriptionWithoutImage.text = course.shortDescription ?? ""
            logoWithoutImage.kf.setImage(with: URL(string: course.logo ?? ""))
        }
        
        if let description = course.description,
           description.isEmpty == false {
            stackView.addArrangedSubview(descriptionTitleView)
            stackView.addArrangedSubview(descriptionView)
            descriptionView.isScrollEnabled = false
            descriptionView.load(markdown: course.description)
        } else {
            descriptionTitleView.removeFromSuperview()
            descriptionView.removeFromSuperview()
        }
        
        stackView.addArrangedSubview(lecturesTitleView)
        stackView.addArrangedSubview(spaceView)
    }
    
    private func bind() {
        registerButton.rx.tap
            .compactMap { [weak self] in
                self?.reactor.currentState.isRegistered
            }.map {
                let query: CourseRegisterQuery = $0 ? .unregister : .register
                return .didRegisterClicked(query: query)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap(\.course)
            .bind(onNext: setupStackView)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isRegistered)
            .bind { [weak self] registered in
                guard let registered else {
                    self?.registerButton.isHidden = true
                    self?.registerButtonLabel.isHidden = true
                    return
                }
                
                self?.registerButton.backgroundColor = registered ?
                UIColor(resource: .red01) : UIColor(resource: .blue01)
                self?.registerButtonLabel.text = registered ?
                "수강 취소" : "수강 신청"
            }
            .disposed(by: disposeBag)
    }
}
