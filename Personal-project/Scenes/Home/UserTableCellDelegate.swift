//
//  UserTableCellDelegate.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import Foundation

protocol UserTableCellDelegate: AnyObject {
    func updateAdminUsername(userId: Int, username: String)
    func deleteUser(userId: Int, username: String)
    func updateAuthority(userId: Int)
}
