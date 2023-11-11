//
//  CourseListRequestDTO.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation

struct CourseListRequestDTO: Encodable {
    let offset: Int
    let count: Int
    let filterIsRecommended: Bool?
    let filterIsFree: Bool?
    let filterConditions: ConditionsDTO?
    
    enum CodingKeys: String, CodingKey {
        case offset
        case count
        case filterIsRecommended = "filter_is_recommended"
        case filterIsFree = "filter_is_free"
        case filterConditions = "filter_conditions"
    }
    
    struct ConditionsDTO: Encodable {
        let courseIds: [String]
        
        enum CodingKeys: String, CodingKey {
            case courseIds = "course_ids"
        }
    }
}
