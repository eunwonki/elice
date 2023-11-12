//
//  CourseReponseDTO+Mapping.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation

struct CourseResponseDTO: Decodable {
    let course: CourseDTO
    let result: EliceResultStatusResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case course
        case result = "_result"
    }
}
