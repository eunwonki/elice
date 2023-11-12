//
//  CourseRequestDTO+Mapping.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation

struct CourseRequestDTO: Encodable {
    let courseId: String
    
    enum CodingKeys: String, CodingKey {
        case courseId = "course_id"
    }
}
