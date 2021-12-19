//
//  APIResponse.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import Foundation


/// API Response
protocol APIResponse: Decodable {
    associatedtype DataType: Decodable
    
    var success: Bool? { get }
    var msg: String? { get }
    var data: DataType? { get }
}

/// APIResult
struct APIResult<T: Decodable> {
    var error: APIError?
    var response: T?
}

/// APIError
enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}
