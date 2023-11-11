//
//  CourseCell.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import UIKit

final class CourseCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CourseCell.self)
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tagView: UIView!
    
    func bind(_ course: Course) {
        titleLabel.text = course.title
        descriptionLabel.text = course.description
    }
}
