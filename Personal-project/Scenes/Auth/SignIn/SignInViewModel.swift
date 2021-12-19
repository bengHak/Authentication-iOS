//
//  SignInViewModel.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import Foundation
import RxSwift
import RxRelay
import SwiftKeychainWrapper

protocol SignInInput {
    var email: String { get }
    var password: String { get }
}

protocol SignInOutput {
    var isSignedIn: BehaviorRelay<Bool> { get }
}

class SignInViewModel {
    
    var apiRequest = APIRequest()
    var input = Input()
    var output = Output()
    
    struct Input: SignInInput {
        var email: String = ""
        var password: String = ""
    }

    struct Output: SignInOutput {
        var isSignedIn = BehaviorRelay(value: false)
    }
}

extension SignInViewModel {
    func signIn() {
        apiRequest.requestLogin(email: input.email, password: input.password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                KeychainWrapper.standard.set(response.token ?? "", forKey: "accessToken")
                self.output.isSignedIn.accept(true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
