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

    func updateUsernameWithAdmin(userId: Int, username: String) {
        apiRequest.requestAdminUpdateUsername(userId: userId, username: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.verifyIsAdminUser()
            case .failure(_):
                print("failed to update admin username")
            }
        }
    }

    func deleteUser(userId: Int) {
        apiRequest.requestUserDelete(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.verifyIsAdminUser()
            case .failure(_):
                print("failed to delete user")
            }
        }
    }

    func updateAuthority(userId: Int, authority: Authority) {
        apiRequest.requestUpdateAuthority(userId: userId, authority: authority.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.verifyIsAdminUser()
            case .failure(_):
                print("failed to update authority")
            }
        }
    }

    
    func signOut() {
        KeychainWrapper.standard.remove(forKey: "accessToken")
    }
    
    
    enum Authority: Int {
        case admin = 1
        case user = 0
    }
}
