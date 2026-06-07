//
//  APILogger.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 07/06/26.
//

import Foundation
import Alamofire

final class APILogger: EventMonitor {
    
    let queue = DispatchQueue(label: "network.logger")
    
    // MARK: - Request Started
    
    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        
#if DEBUG
        print("\n================ REQUEST =================")
        
        if let url = urlRequest.url {
            print("URL:", url.absoluteString)
        }
        
        if let method = urlRequest.method {
            print("METHOD:", method.rawValue)
        }
        
        if let headers = urlRequest.allHTTPHeaderFields {
            print("HEADERS:", headers)
        }
        
        if let body = urlRequest.httpBody {
            if let json = try? JSONSerialization.jsonObject(with: body) {
                print("BODY:", json)
            } else if let bodyString = String(data: body, encoding: .utf8) {
                print("BODY:", bodyString)
            }
        }
        
        print("==========================================\n")
#endif
    }
    
    // MARK: - Response Received
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        
#if DEBUG
        print("\n================ RESPONSE ================")
        
        if let url = request.request?.url {
            print("URL:", url.absoluteString)
        }
        
        if let statusCode = response.response?.statusCode {
            print("STATUS CODE:", statusCode)
        }
        
        if let data = response.data,
           let json = try? JSONSerialization.jsonObject(with: data) {
            print("RESPONSE:", json)
        }
        
        print("==========================================\n")
#endif
    }
}
