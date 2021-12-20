//
//  UserTableViewCell.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import UIKit
import SnapKit
import Then

class UserTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    private let labelUserId = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 14)
    }

    private let labelUserName = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 14)
    }

    private let labelUserEmail = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 14)
    }

    private let labelUserCreatedAt = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 14)
    }

    let buttonUpdateUsername = UIButton().then {
        $0.setTitle("이름수정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
    }

    let buttonDeleteUser = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
    }
    
    let buttonUpdateAuthority = UIButton().then {
        $0.setTitle("권한수정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
    }

    let labelAdmin = UILabel().then {
        $0.text = "관리자"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .red
    }

    // MARK: - Properties
    static let identifier = "UserTableViewCell"
    let apiRequest = APIRequest()
    var userProfileData: AdminUserProfileData?
    var delegate: UserTableCellDelegate?

    // MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: UserTableViewCell.identifier)
        self.setUI()
        self.setButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        self.contentView.addSubview(labelUserId)
        self.contentView.addSubview(labelUserName)
        self.contentView.addSubview(labelUserEmail)
        self.contentView.addSubview(labelUserCreatedAt)
        self.contentView.addSubview(buttonUpdateUsername)
        self.contentView.addSubview(buttonDeleteUser)
        self.contentView.addSubview(buttonUpdateAuthority)
        self.contentView.addSubview(labelAdmin)
        
        labelUserId.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(20)
        }

        labelAdmin.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.trailing.equalToSuperview().inset(20)
        }
        labelAdmin.isHidden = true
        
        labelUserName.snp.makeConstraints {
            $0.top.equalTo(labelUserId.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        labelUserEmail.snp.makeConstraints {
            $0.top.equalTo(labelUserName.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        labelUserCreatedAt.snp.makeConstraints {
            $0.top.equalTo(labelUserEmail.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        buttonUpdateUsername.snp.makeConstraints {
            $0.top.equalTo(labelUserCreatedAt.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        buttonDeleteUser.snp.makeConstraints {
            $0.top.equalTo(labelUserCreatedAt.snp.bottom).offset(6)
            $0.leading.equalTo(buttonUpdateUsername.snp.trailing).offset(6)
        }
        
        buttonUpdateAuthority.snp.makeConstraints {
            $0.top.equalTo(labelUserCreatedAt.snp.bottom).offset(6)
            $0.leading.equalTo(buttonDeleteUser.snp.trailing).offset(6)
        }
    }
    
    func setButtons() {
        buttonDeleteUser.addTarget(self, action: #selector(deleteUser(_:)), for: .touchUpInside)
        buttonUpdateUsername.addTarget(self, action: #selector(updateUsername(_:)), for: .touchUpInside)
        buttonUpdateAuthority.addTarget(self, action: #selector(updateAuthority(_:)), for: .touchUpInside)
    }
    
    @objc func deleteUser(_ sender: Any) {
        guard let userId = userProfileData?.id,
              let username = userProfileData?.username else {
                  return
              }
        delegate?.deleteUser(userId: userId, username: username)
    }
    
    @objc func updateUsername(_ sender: Any) {
        guard let userId = userProfileData?.id,
              let username = userProfileData?.username else {
                  return
              }
        delegate?.updateAdminUsername(userId: userId, username: username)
    }
    
    @objc func updateAuthority(_ sender: Any) {
        guard let userId = userProfileData?.id else { return }
        delegate?.updateAuthority(userId: userId)
    }
    
    func setData(model: AdminUserProfileData) {
        userProfileData = model
        labelUserId.text = "ID: \(model.id ?? -1)"
        labelUserName.text = "이름: \(model.username ?? "")"
        labelUserEmail.text = "이메일: \(model.email ?? "")"
        labelUserCreatedAt.text = "가입일: \((model.created_at ?? "").split(separator: "T")[0])"

        if userProfileData?.authority == 1 {
            labelAdmin.isHidden = false
        } else {
            labelAdmin.isHidden = true
        }
    }
}

