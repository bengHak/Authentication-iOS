//
//  SignUpViewModel.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import Foundation
import RxSwift
import RxRelay
import SwiftKeychainWrapper

protocol SignUpInput {
    var email: String { get }
    var username: String { get }
    var password: String { get }
    var passwordConfirm: String { get }
}

protocol SignUpDependency {
    var isEmailDuplicated: BehaviorRelay<Bool> { get }
}

protocol SignUpOutput {
    var isSignedUp: BehaviorRelay<Bool> { get }
}

class SignUpViewModel {
    
    var apiRequest = APIRequest()
    var input = Input()
    var dependency = Dependency()
    var output = Output()
    
    struct Input: SignUpInput {
        var email: String = ""
        var username: String = ""
        var password: String = ""
        var passwordConfirm: String = ""
    }
    
    struct Dependency: SignUpDependency {
        var isEmailDuplicated = BehaviorRelay<Bool>(value: false)
    }
    
    struct Output: SignUpOutput {
        var isSignedUp = BehaviorRelay(value: false)
    }
}

extension SignUpViewModel {
    func signUp() {
        apiRequest.requestSignUp(email: input.email, username: input.username, password: input.password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                KeychainWrapper.standard.set(token, forKey: "accessToken")
                self.output.isSignedUp.accept(true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendCodeMail() {
        apiRequest.request2SendMail(email: input.email) { (result) in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func verifyEmail() {
        apiRequest.verifyEmail(email: input.email) { [weak self] result in
            switch result {
            case .success(let isNotExist):
                self?.dependency.isEmailDuplicated.accept(!isNotExist)
            case .failure(let error):
                print(error)
            }
        }
    }
}
