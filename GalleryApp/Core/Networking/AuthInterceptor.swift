//
//  AuthInterceptor.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 07/06/26.
//

/*
RequestInterceptor automatically attaches the access token to every request.
If a request fails with 401 Unauthorized, it refreshes the token and retries the request.
If token refresh fails, the error is returned and the user can be logged out.
*/

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {

    // MARK: - Adapt : request phase (Add Token)

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {

        var request = urlRequest
        
        debugPrint("AuthInterceptor.adapt called")
        debugPrint("Request URL:", request.url?.absoluteString ?? "")

        // MARK: Currently not needed as we are fetching public API
        /*if let token = Utility.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ No access token found")
        }*/

        completion(.success(request))
    }

    // MARK: - Retry : response/error phase (Handle 401)
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {

        let statusCode = request.response?.statusCode ?? 0

        guard statusCode == 401, Utility.getAccessToken() != nil else {
            completion(.doNotRetry)
            return
        }

        completion(.retry)

        // Prevent infinite loop
        guard request.retryCount < 1 else {
            completion(.doNotRetry)
            return
        }

        // Token refresh is not needed for the current current public API.
        // This retry mechanism can be enabled when access/refresh token authentication is added.
       
        /*refreshToken { success in
            completion(success ? .retry : .doNotRetry)
        }*/
    }
}

