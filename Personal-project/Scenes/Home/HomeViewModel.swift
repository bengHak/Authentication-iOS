//
//  HomeViewModel.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

protocol HomeDependency {
    var isSignedIn: Bool { get }
    var isAdmin: BehaviorRelay<Bool> { get }
}

protocol HomeOutput {
    var userProfile: BehaviorRelay<ProfileData?> { get }
    var userList: BehaviorRelay<[AdminUserProfileData]?> { get }
}

class HomeViewModel {
    
    var apiRequest = APIRequest()
    var bag = DisposeBag()
    var dependency = Dependency()
    var output = Output()
    
    struct Dependency: HomeDependency {
        var isSignedIn: Bool {
            let token: String? = KeychainWrapper.standard.string(forKey: "accessToken")
            return token != nil
        }
        var isAdmin = BehaviorRelay<Bool>(value: false)
    }
    
    struct Output: HomeOutput {
        var userProfile = BehaviorRelay<ProfileData?>(value: nil)
        var userList = BehaviorRelay<[AdminUserProfileData]?>(value: [])
    }
    
}

extension HomeViewModel {
    
    func fetchUserProfile() {
        apiRequest.getUserProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(profileData):
                self.output.userProfile.accept(profileData)
            case .failure(_):
                print("failed to fetch profile")
            }
        }
    }
    
    func verifyIsAdminUser() {
        apiRequest.getUserList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(userList):
                self.dependency.isAdmin.accept(true)
                self.output.userList.accept(userList)
            case .failure(_):
                self.dependency.isAdmin.accept(false)
            }
        }
    }
    
    func updateUsername(username: String) {
        apiRequest.requestUpdateUsername(username: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.fetchUserProfile()
            case .failure(_):
                print("failed to update username")
            }
        }
    }
    
    func signOut() {
        KeychainWrapper.standard.remove(forKey: "accessToken")
    }
    
}
