//
//  HomeViewModel.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeDependency {
    var isSignedIn: Bool { get }
    var isAdmin: Bool { get }
}

protocol HomeOutput {
    var userProfile: BehaviorRelay<ModelUserProfile> { get }
}

class HomeViewModel {
    
    var apiRequest = APIRequest()
    var bag = DisposeBag()
    
    
}

extension HomeViewModel {
    
    func fetchUserProfile() {

    }
    
    func updateUserProfile() {
        
    }
    
    func signOut() {
        
    }
}
