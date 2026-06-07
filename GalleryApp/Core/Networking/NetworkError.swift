//
//  NetworkError.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 07/06/26.
//

import Foundation

enum NetworkError: LocalizedError {

    // API error message from backend
    case apiError(String)

    // Network level
    case noInternet
    case timeout
    case cancelled

    // HTTP errors
    case badRequest        // 400
    case unauthorized      // 401
    case forbidden         // 403
    case notFound          // 404
    case serverError       // 500

    // App side
    case decodingError
    case invalidURL
    case unknown
    case custom(String)

    var errorDescription: String? {
        switch self {

        case .apiError(let message):
            return message

        case .noInternet:
            return "No internet connection"

        case .timeout:
            return "Request timeout"

        case .cancelled:
            return "Request cancelled"

        case .badRequest:
            return "Bad request"

        case .unauthorized:
            return "Session expired. Please login again"

        case .forbidden:
            return "Access denied"

        case .notFound:
            return "Resource not found"

        case .serverError:
            return "Server error"

        case .decodingError:
            return "Response parsing failed"

        case .invalidURL:
            return "Invalid URL"

        case .unknown:
            return "Something went wrong"
            
        case .custom(let message):
            return message
            
        }
    }
}

