//
//  LectureCell.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation
import UIKit

final class LectureCell: UITableViewCell {
    static let reuseIdentifier = String(describing: LectureCell.self)
    static let height: CGFloat = 80
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineToNext: UIView!
    
    func bind(_ lecture: Lecture) {
        titleLabel.text = lecture.title
        descriptionLabel.text = lecture.description
    }
}
