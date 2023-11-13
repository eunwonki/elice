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
    let filterIsRecommended: String?
    let filterIsFree: String?
    let filterConditions: ConditionsDTO?
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.offset, forKey: .offset)
        try container.encode(self.count, forKey: .count)
        try container.encodeIfPresent(
            self.filterIsRecommended,
            forKey: .filterIsRecommended)
        try container.encodeIfPresent(
            self.filterIsFree,
            forKey: .filterIsFree)
        
        if let filterConditions {
            try container.encodeIfPresent(
                encodeConditionsToURLQuery(),
                forKey: .filterConditions)
        }
    }
    
    /// json encodable한 변수를 elice api query에 맞게 문자열로 변형
    private func encodeConditionsToURLQuery() -> String? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(filterConditions)
        else {
            return nil
        }
        let jsonString = String(data: jsonData, encoding: .utf8)
        var alloweddCharaterSet = CharacterSet.urlQueryAllowed
        alloweddCharaterSet.remove(charactersIn: ",:")
        return jsonString?
            .addingPercentEncoding(
                withAllowedCharacters: alloweddCharaterSet)?
            .removingPercentEncoding
    }
    
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
        
        func encode(to encoder: Encoder) throws {
            var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
            let ids = self.courseIds.compactMap(Int.init)
            try container.encode(ids, forKey: .courseIds)
        }
    }
}
