//
//  LectureDTO+Mapping.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation

struct LectureDTO: Decodable {
    let id: Int
    let orderNo: Int
    let title: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderNo = "order_no"
        case title
        case description
    }
}

extension LectureDTO {
    func toDomain() -> Lecture {
        return .init(
            id: String(id),
            orderNo: orderNo,
            title: title,
            description: description
        )
    }
}
