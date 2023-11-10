//
//  APIEndpoints.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation

struct APIEndpoints {
    
    static func getCourseList(
        with request: CourseListRequestDTO
    ) -> Endpoint<CourseListResponseDTO> {
        return Endpoint(
            path: "academy/course/list/",
            isFullPath: false,
            method: .get,
            queryParameters: request
        )
    }
    
}
