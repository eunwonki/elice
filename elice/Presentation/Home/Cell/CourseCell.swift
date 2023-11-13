//
//  CourseCell.swift
//  elice
//
//  Created by wonki on 11/11/23.
//

import Foundation
import Kingfisher
import UIKit

final class CourseCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CourseCell.self)
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tagLabel: UILabel!
    
    func bind(_ course: Course) {
        titleLabel.text = course.title
        descriptionLabel.text = course.shortDescription
        
        if let image = course.image,
           let url = URL(string: image) {
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
        } else if let logo = course.logo,
                  let url = URL(string: logo) {
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFit
        }
        
        tagLabel.text = course.taglist.joined(separator: ", ")
    }
}
