//
//  EliceResultStatusResponseDTO.swift
//  elice
//
//  Created by wonki on 11/10/23.
//

import Foundation

struct EliceResultStatusResponseDTO: Decodable {
    let status: Status
    let reason: String?
    
    enum Status: String, Decodable {
        case ok
    }
}
