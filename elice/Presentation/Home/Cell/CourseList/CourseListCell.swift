//
//  CourseCell.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift

final class CourseListCell: UITableViewCell {
    class SingleSection {
        typealias CourseSectionModel = SectionModel<Int, CourseItem>
        
        enum CourseItem: Equatable {
            case firstItem(Course)
        }
    }
    
    static let reuseIdentifier = String(describing: CourseListCell.self)
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    private var reactor: CourseListViewReactor!
    private var disposeBag = DisposeBag()
    
    func bind(with reactor: CourseListViewReactor) {
        self.selectionStyle = .none
        self.reactor = reactor
        
        collectionView.rx.itemSelected
            .map { .selectItem(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SingleSection.CourseSectionModel> {
            dataSource, tableView, indexPath, item in
            switch item {
            case .firstItem(let course):
                guard let cell = self.collectionView.dequeueReusableCell(
                    withReuseIdentifier: CourseCell.reuseIdentifier,
                    for: indexPath
                ) as? CourseCell else {
                    return UICollectionViewCell()
                }
                
                cell.bind(course)
                
                if indexPath.row == reactor.currentState.offset - 1 {
                    reactor.action.onNext(.loadMorePage)
                }
                
                return cell
            }
        }
        
        reactor.state.map(\.courseSection)
            .distinctUntilChanged()
            .map(Array.init(with:))
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}
