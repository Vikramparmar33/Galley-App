//
//  Encodable+Extension.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

// MARK: - Encodable Helpers (Codable → JSON Utilities)
extension Encodable {
    
    /// Converts any Encodable object into a Dictionary
    /// - Returns: `[String: Any]` representation of the model (similar to ObjectMapper's `toJSON()`)
    /// - Note: Useful for query parameters, logging, or debugging
    func toDictionary() -> [String: Any]? {
        // Encode model to JSON Data
        guard let data = try? JSONEncoder().encode(self),
              // Convert Data → JSON Object
              let json = try? JSONSerialization.jsonObject(with: data),
              // Cast JSON Object → Dictionary
              let dict = json as? [String: Any] else {
            return nil
        }
        return dict
    }
    
    /// Converts Encodable object into a compact JSON String
    /// - Returns: Minified JSON string (no formatting)
    /// - Note: Useful for API logging or debugging raw payload
    func toJSONString() -> String? {
        // Encode model to JSON Data
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        // Convert Data → String
        return String(data: data, encoding: .utf8)
    }
    
    /// Converts Encodable object into a pretty-printed JSON String
    /// - Returns: Formatted JSON string (readable)
    /// - Note: Best for debugging and console logs
    func toPrettyJSON() -> String {
        let encoder = JSONEncoder()
        
        // Enable pretty print formatting
        encoder.outputFormatting = .prettyPrinted
        
        // Encode model to JSON Data
        guard let data = try? encoder.encode(self) else { return "" }
        
        // Convert Data → String
        return String(data: data, encoding: .utf8) ?? ""
    }
}
