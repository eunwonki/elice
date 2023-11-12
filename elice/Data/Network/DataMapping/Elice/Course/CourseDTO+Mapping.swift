//
//  CourseDTO.swift
//  elice
//
//  Created by wonki on 11/12/23.
//

import Foundation

struct CourseDTO: Decodable {
    let id: Int
    let title: String
    let shortDescription: String?
    let description: String?
    let logoFileUrl: String?
    let imageFileUrl: String?
    let tags: [TagDTO]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case shortDescription = "short_description"
        case description
        case logoFileUrl = "logo_file_url"
        case imageFileUrl = "image_file_url"
        case tags
    }
}

struct TagDTO: Decodable {
    var id: Int
    var name: String
}

// MARK: - To Domain

extension CourseDTO {
    func toDomain() -> Course {
        .init(
            id: String(id), title: title,
            logo: logoFileUrl,
            image: imageFileUrl,
            shortDescription: shortDescription,
            description: description,
            tags: tags.map { $0.toDomain() }
        )
    }
}

extension TagDTO {
    func toDomain() -> Course.Tag {
        .init(id: String(id), name: name)
    }
}
