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
    
    struct CourseDTO: Decodable {
        let id: Int
        let title: String
        let shortDescription: String
        let logoFileUrl: String?
        let imageFileUrl: String?
        let tags: [TagDTO]
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case shortDescription = "short_description"
            case logoFileUrl = "logo_file_url"
            case imageFileUrl = "image_file_url"
            case tags
        }
    }
    
    struct TagDTO: Decodable {
        var id: Int
        var name: String
    }
}

// MARK: - To Domain

extension CourseListResponseDTO.CourseDTO {
    func toDomain() -> Course {
        .init(
            id: String(id), logo: logoFileUrl,
            image: imageFileUrl, title: title,
            description: shortDescription,
            tags: tags.map { $0.toDomain() }
        )
    }
}

extension CourseListResponseDTO.TagDTO {
    func toDomain() -> Course.Tag {
        .init(id: String(id), name: name)
    }
}
