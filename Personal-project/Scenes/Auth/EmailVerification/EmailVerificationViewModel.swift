//
//  EmailVerificationViewModel.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import Foundation
import RxSwift
import SwiftKeychainWrapper
import RxRelay

protocol EmailVerificationInput {
    var code: String { get set }
}

protocol EmailVerificationOutput {
    var isSignedUp: BehaviorRelay<Bool> { get }
    var isVerified: BehaviorRelay<Bool> { get }
}

class EmailVerificationViewModel {
    var apiRequest = APIRequest()
    var bag = DisposeBag()
    var input = Input()
    var output = Output()
    
    struct Input: EmailVerificationInput {
        var code = ""
    }
    
    struct Output: EmailVerificationOutput {
        var isSignedUp = BehaviorRelay<Bool>(value: false)
        var isVerified = BehaviorRelay<Bool>(value: false)
    }
}

extension EmailVerificationViewModel {
    func verifyCode(email: String, code: String) {
        apiRequest.verifyCode(email: email, code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.output.isVerified.accept(success)
                if success {
                    print("인증 성공")
                } else {
                    print("인증 실패 ")
                }
            case .failure(_):
                print("네트워킹 실패")
            }
        }
    }
    
    func signUp(email: String, username: String, password: String) {
        apiRequest.requestSignUp(email: email, username: username, password: password) { [weak self] (result) in
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
}
