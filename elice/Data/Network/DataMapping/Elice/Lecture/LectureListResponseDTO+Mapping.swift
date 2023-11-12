//
//  LectureListResponseDTO+Mapping.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation

struct LectureListResponseDTO: Decodable {
    let result: EliceResultStatusResponseDTO
    let lectures: [LectureDTO]
    let lectureCount: Int
    
    enum CodingKeys: String, CodingKey {
        case result = "_result"
        case lectures
        case lectureCount = "lecture_count"
    }
}
