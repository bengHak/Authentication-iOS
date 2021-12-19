//
//  ModelGetUserProfile.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/19.
//

import Foundation

struct ModelUserProfile: APIResponse {
    var success: Bool?
    var msg: String?
    var data: ProfileData?
}

struct ProfileData: Decodable {
    var id: Int?
    var username: String?
    var email: String?
}
