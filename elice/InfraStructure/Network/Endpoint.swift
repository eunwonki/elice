//
//  Endpoint.swift
//  elice
//
//  Created by wonki on 11/1/23.
//

import Foundation
import Alamofire

enum RequestGenerationError: Error {
    case components
}

class Endpoint<R> where R: Decodable {
    let path: String
    let isFullPath: Bool
    let method: HTTPMethod
    let headerParameters: [String: String]
    let queryParameters: Encodable?
    let bodyParameters: Encodable?
    let cachePolicy: URLRequest.CachePolicy
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod = .get,
         headerParameters: [String : String] = [:],
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.cachePolicy = cachePolicy
    }
    
    func url(with config: NetworkConfigurable) throws -> URL {
        
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        
        let queryParameters = try queryParameters?.toDictionary()
        if let queryParameters = queryParameters {
            queryParameters.forEach {
                urlQueryItems.append(URLQueryItem(
                    name: $0.key, value: "\($0.value)"))
            }
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(
                name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy)
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        if let bodyParameters {
            urlRequest.httpBody = try JSONEncoder().encode(bodyParameters)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}

