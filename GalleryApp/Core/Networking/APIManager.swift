//
//  APIManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 07/06/26.
//

import Foundation
import Alamofire

struct APIError: Decodable {
    let status: String?
    let message: String?
}

class APIManager {

    static let shared = APIManager()
    private init() {}

    // Centralized Alamofire session with auth handling and request logging.
    let session = Session(
        interceptor: AuthInterceptor(),
        eventMonitors: [APILogger()]
    )
    
    func request<T: Decodable, P: Encodable>(
        endpoint: Endpoint,
        parameters: P? = nil
    ) async throws -> T {
        
        let response = await session.request(
            endpoint.url,
            method: endpoint.method,
            parameters: parameters,
            encoder: endpoint.parameterEncoder
        )
        .validate(statusCode: 200..<300) // Accept only successful HTTP responses.
        .serializingDecodable(T.self)
        .response
        
        switch response.result {
           
        // SUCCESS
        case .success(let value):
            return value
        
        // FAILURE
        case .failure(let error):
            // Convert Alamofire and backend errors into app-specific errors.
            throw mapError(response: response, error: error)
            
        }
        
    }
    
    private func mapError<T>(response: AFDataResponse<T>,error: Error) -> NetworkError {

        if let afError = error.asAFError {

            // Handle connectivity-related failures.
            if afError.isSessionTaskError {
                return .noInternet
            }

            // Handle invalid or unexpected response models.
            if afError.isResponseSerializationError {
                return .decodingError
            }
        }

        let statusCode = response.response?.statusCode ?? -1

        switch statusCode {

        case 401:
            // Authentication expired or invalid.
            return .unauthorized

        case 403:
            // User does not have permission to access the resource.
            return .forbidden

        case 412:
            // Backend validation/business logic failure.
            return .apiError(
                parseBackendError(data: response.data)
            )

        case 500..<600:
            // Server-side failure.
            return .serverError

        default:
            // Fallback for all other API errors.
            return .apiError(
                parseBackendError(data: response.data)
            )
        }
    }
    
    private func parseBackendError(data: Data?) -> String {

        guard let data = data else {
            return NetworkError.decodingError.localizedDescription
        }

        do {
            // Extract backend error message from response payload.
            let error = try JSONDecoder().decode(APIError.self, from: data)
            return error.message ?? NetworkError.unknown.localizedDescription
        } catch {
            // Fallback when error response cannot be decoded.
            return NetworkError.unknown.localizedDescription
        }
    }
    
}

