//
//  Endpoint.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 07/06/26.
//

import Alamofire

enum Endpoint {
    case list
}

extension Endpoint {

    var baseURL: String {
        AppEnvironment.serverBaseURL
    }

    var url: String {
        baseURL + path
    }

}

// MARK: - Path Mapping
extension Endpoint {
    
    var path: String {
        
        switch self {
            
        // Gallery list
        case .list:
            return "/list"
        }
    }
    
}

// MARK: - HTTP Method
extension Endpoint {

    var method: HTTPMethod {

        switch self {

        case .list:
            return .get
        }
        
    }

}
    
// MARK: - Parameter Encoding
extension Endpoint {

    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }

    var parameterEncoder: ParameterEncoder {
        switch method {
        case .get:
            return URLEncodedFormParameterEncoder.default
        default:
            return JSONParameterEncoder.default
        }
    }
}
