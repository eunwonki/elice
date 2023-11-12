//
//  CourseListResponseDTO.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation

struct CourseListResponseDTO: Decodable {
    let courses: [CourseDTO]
    let courseCount: Int
    let result: EliceResultStatusResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case courses
        case courseCount = "course_count"
        case result = "_result"
    }
}
