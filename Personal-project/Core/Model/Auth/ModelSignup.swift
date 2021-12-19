//
//  ModelSignup.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import Foundation

struct ModelSignUpRequest: Encodable {
    var email: String
    var password: String
    var username: String
}

struct ModelSignUpResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: String?
}
