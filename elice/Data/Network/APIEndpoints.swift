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
    
    static func getCourse(
        with request: CourseRequestDTO
    ) -> Endpoint<CourseResponseDTO> {
        return Endpoint(
            path: "academy/course/get/",
            isFullPath: false,
            method: .get,
            queryParameters: request
        )
    }
    
    static func getLectureList(
        with request: LectureListRequestDTO
    ) -> Endpoint<LectureListResponseDTO> {
        return Endpoint(
            path: "academy/lecture/list/",
            isFullPath: false,
            method: .get,
            queryParameters: request
        )
    }
}
