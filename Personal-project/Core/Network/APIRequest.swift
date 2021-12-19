//
//  APIRequest.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct APIRequest {
    
    func getUserProfile(handler: @escaping (Result<ProfileData, APIError>) -> Void) {
        let endpoint: API = .requestMyProfile
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: Alamofire.HTTPHeaders = ["Authorization": "Bearer " + (accessToken ?? "")]
        
        AF.request(urlString, method: method, headers: headers)
            .responseDecodable(of: ModelUserProfile.self) { response in
                
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("unauthorized")
                        return
                    }
                    guard let profileData = responseData.data else {
                              handler(.failure(.decodingError))
                              return
                          }
                    handler(.success(profileData))
                case .failure(_):
                    handler(.failure(.unknown))
                }
                
                
                
                return
            }
    }
    
    
    func responseHandler() {
        
    }
}
