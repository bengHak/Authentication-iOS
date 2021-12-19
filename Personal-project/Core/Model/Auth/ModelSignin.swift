//
//  ModelSignin.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import Foundation

struct ModelSignInRequest: Encodable {
    var email: String
    var password: String
}

struct ModelSignInResponse: APIResponse {
    var success: Bool?
    var msg: String?
    var data: ModelSignInResult?
}

struct ModelSignInResult: Decodable {
    var id: Int?
    var authority: Int?
    var token: String?
}
