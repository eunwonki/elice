//
//  LectureListRequestDTO+Mapping.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation

struct LectureListRequestDTO: Encodable {
    let offset: Int
    let count: Int
    let courseId: String
    
    enum CodingKeys: String, CodingKey {
        case offset
        case count
        case courseId = "course_id"
    }
}
