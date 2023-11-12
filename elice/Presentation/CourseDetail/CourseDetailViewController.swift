//
//  CourseDetailViewController.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import MarkdownView
import UIKit

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
    
    static func create() -> CourseDetailViewController {
        CourseDetailViewController.instantiateViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        bind()
    }
    
    @IBAction func backButtonTouchUp() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        stackView.removeArrangedSubview(titleWithImageView)
        stackView.addArrangedSubview(titleWithoutImageView)
        
        stackView.addArrangedSubview(descriptionTitleView)
        
        stackView.addArrangedSubview(descriptionView)
        descriptionView.isScrollEnabled = false
        
        stackView.addArrangedSubview(lecturesTitleView)
        
        stackView.addArrangedSubview(spaceView)
    }
    
    private func bind() {
        descriptionView.load(markdown: "### **파이썬 기초에서 한 걸음 더! 배운 것을 응용하는 법을 배워요.**\r\n파이썬의 기초 자료형, 조건문, 리스트와 반복문을 배우셨나요? 이번에는 코드를 짜는 데에 어떻게 이들을 활용하는지 배워봅시다! 더 많은 파이썬의 자료형에서부터 객체 지향 프로그래밍에 대한 기본 개념까지 학습해봐요.\r\n <br>\r\n### **실습을 통해 파이썬 함수와 자연스레 친해지세요.**\r\n프로그래밍에서 정~말 중요한 함수. 함수를 사용하면 반복되는 작업을 하지 않아도 될 뿐만 아니라 프로그램을 한눈에 파악하기 좋아져요. 이 과목에서는 직접 함수를 만들고 만든 함수를 모듈에 저장해 불러오는 법을 실습을 통해 익힙니다. 출퇴근길, 등하굣길 30분씩만 실습에 투자하면 자연스레 함수와 친해질 수 있어요. 유능한 프로그래머에 한 걸음 더 가까워지세요!\r\n <br>\r\n### **객체지향 프로그래밍을 위한 디딤돌!**\r\n빅데이터 시대에 더욱 중요한 '객체'! 효율적으로 데이터를 처리하기 위해서는 각자의 역할을 수행하는 '객체'가 꼭 필요해요. 이 과목에서 객체지향 프로그래밍의 기본 개념을 익히고 객체지향 프로그래밍을 위한 기초 체력을 탄탄히 해보세요!")
    }
}
