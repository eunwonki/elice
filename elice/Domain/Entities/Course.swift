//
//  Course.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation

struct Course: Equatable {
    let id: String
    let logo: String?
    let image: String?
    let title: String
    let description: String
    let tags: [Tag]
    
    struct Tag {
        let id: String
        let name: String
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
}
