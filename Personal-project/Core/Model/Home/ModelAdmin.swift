//
//  ModelAdmin.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import Foundation

struct ModelUserList: APIResponse {
    var success: Bool?
    var msg: String?
    var data: [AdminUserProfileData]?
}

struct AdminUserProfileData: Decodable {
    var id: Int?
    var username: String?
    var email: String?
    var authority: Int?
    var createdAt: String?
    var updatedAt: String?
}
