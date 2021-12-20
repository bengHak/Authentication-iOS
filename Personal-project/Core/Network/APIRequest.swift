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
    
    /// 자신의 프로필 불러오기
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
    
    /// 관리자 권한으로 유저 목록 불러오기
    func getUserList(handler: @escaping (Result<[AdminUserProfileData], APIError>) -> Void) {
        let endpoint: API = .requestUserList
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: Alamofire.HTTPHeaders = ["Authorization": "Bearer " + (accessToken ?? "")]
        
        AF.request(endpoint.path, method: endpoint.httpMethod, headers: headers)
            .responseDecodable(of: ModelUserList.self) { response in
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("[get user list] unauthorized")
                        return
                    }
                    guard let userList = responseData.data else {
                              handler(.failure(.decodingError))
                              return
                          }
                    handler(.success(userList))
                    
                case .failure(_):
                    handler(.failure(.unknown))
                }
            }
    }

    // 로그인 요청
    func requestLogin(email: String, password: String, handler: @escaping (Result<ModelSignInResult, APIError>) -> Void) {
        let endpoint: API = .requestSignin
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ModelSignInResponse.self) { response in
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("[request login] unauthorized")
                        return
                    }
                    guard let loginData = responseData.data else {
                              handler(.failure(.decodingError))
                              return
                          }
                    handler(.success(loginData))
                    
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }

    // 회원가입: 이메일, 비밀번호, 유저네임
    func requestSignUp(email: String, username: String, password: String, handler: @escaping (Result<String, APIError>) -> Void) {
        let endpoint: API = .requestSignup
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let parameters: [String: Any] = [
            "email": email,
            "username": username,
            "password": password
        ]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ModelSignUpResponse.self) { response in
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("[request sign up] unauthorized")
                        return
                    }
                    guard let signUpData = responseData.data else {
                              handler(.failure(.decodingError))
                              return
                          }
                    handler(.success(signUpData))
                    
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }

    // username 수정
    func requestUpdateUsername(username: String, handler: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint: API = .requestUpdateProfile
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: Alamofire.HTTPHeaders = ["Authorization": "Bearer " + (accessToken ?? "")]
        let parameters: [String: Any] = [
            "username": username
        ]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ModelUpdateUsernameResponse.self) { response in
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("[request update username] unauthorized")
                        return
                    }
                    handler(.success(responseData.success ?? false))
                    
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }
    
    // 관리자 계정으로 사용자 username 수정
    func requestAdminUpdateUsername(userId: Int, username: String, handler: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint: API = .requestUpdateUserProfile(userId: userId)
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: Alamofire.HTTPHeaders = ["Authorization": "Bearer " + (accessToken ?? "")]
        let parameters: [String: Any] = [
            "username": username
        ]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ModelAdminUpdateUsernameResponse.self) { response in
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("[request update username] unauthorized")
                        return
                    }
                    handler(.success(responseData.success ?? false))
                    
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }

    // 유저 삭제
    func requestUserDelete(userId: Int, handler: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint: API = .requestDeleteUser(userId: userId)
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: Alamofire.HTTPHeaders = ["Authorization": "Bearer " + (accessToken ?? "")]
        
        AF.request(urlString, method: method, headers: headers)
            .responseDecodable(of: ModelAdminUpdateUsernameResponse.self) { response in
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("[request user delete] unauthorized")
                        return
                    }
                    handler(.success(responseData.success ?? false))
                    
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }

    // 사용자 권한 설정
    func requestUpdateAuthority(userId: Int, authority: Int, handler: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint: API = .requestUpdateUserAuthority(userId: userId)
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
        let headers: Alamofire.HTTPHeaders = ["Authorization": "Bearer " + (accessToken ?? "")]
        let parameters: Alamofire.Parameters = ["authority" : authority]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ModelAdminUpdateUsernameResponse.self) { response in
                
                switch response.result {
                case let .success(responseData):
                    if let statusCode = response.response?.statusCode,
                       (400..<500).contains(statusCode) {
                        handler(.failure(.httpError(statusCode)))
                        print("[request update authority] unauthorized")
                        return
                    }
                    handler(.success(responseData.success ?? false))
                    
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }
    
    // 인증 코드를 위한 이메일 발신
    func request2SendMail(email: String, handler: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint: API = .requestCodeMail(email: email)
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let parameters: Alamofire.Parameters = [ "email": email ]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ModelAdminUpdateUsernameResponse.self) { response in
                switch response.result {
                case let .success(responseData):
                    handler(.success(responseData.success ?? false))
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }
    
    // 인증 코드 확인
    func verifyCode(email: String, code: String, handler: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint: API = .verifyCode(email: email, code: code)
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let parameters: Alamofire.Parameters = [ "email": email, "code": code ]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ModelAdminUpdateUsernameResponse.self) { response in
                switch response.result {
                case let .success(responseData):
                    handler(.success(responseData.success ?? false))
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }

    // 이메일 중복 확인
    func verifyEmail(email: String, handler: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint: API = .verifyEmail(email: email)
        let urlString = endpoint.path
        let method = endpoint.httpMethod
        let parameters: Alamofire.Parameters = [ "email": email ]
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ModelAdminUpdateUsernameResponse.self) { response in
                switch response.result {
                case let .success(responseData):
                    handler(.success(responseData.success ?? false))
                case .failure(_):
                    handler(.failure(.unknown))
                }
        }
    }
    
    func responseHandler() {
        
    }
}
