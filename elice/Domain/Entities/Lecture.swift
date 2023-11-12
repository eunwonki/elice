//
//  Lecture.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation

struct Lecture: Equatable {
    let id: String
    let orderNo: Int
    let title: String
    let description: String
    
    static func == (lhs: Lecture, rhs: Lecture) -> Bool {
        lhs.id == rhs.id
    }
}
