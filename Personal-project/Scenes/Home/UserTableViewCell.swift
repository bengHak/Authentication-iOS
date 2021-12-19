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

    private let buttonUpdateUsername = UIButton().then {
        $0.setTitle("이름수정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
    }

    private let buttonDeleteUser = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
    }
    

    // MARK: - Properties
    static let identifier = "UserTableViewCell"
    

    // MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: UserTableViewCell.identifier)
        self.setUI()
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
        
        labelUserId.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(6)
        }
        
        labelUserName.snp.makeConstraints {
            $0.top.equalTo(labelUserId.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(6)
        }
        
        labelUserEmail.snp.makeConstraints {
            $0.top.equalTo(labelUserName.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(6)
        }
        
        labelUserCreatedAt.snp.makeConstraints {
            $0.top.equalTo(labelUserEmail.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(6)
        }
        
        buttonUpdateUsername.snp.makeConstraints {
            $0.top.equalTo(labelUserCreatedAt.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(6)
        }
        
        buttonDeleteUser.snp.makeConstraints {
            $0.top.equalTo(labelUserCreatedAt.snp.bottom).offset(6)
            $0.leading.equalTo(buttonUpdateUsername.snp.trailing).offset(6)
        }
        
    }
    
    func setData(model: AdminUserProfileData) {
        labelUserId.text = "ID: \(model.id ?? -1)"
        labelUserName.text = "이름: \(model.username ?? "")"
        labelUserEmail.text = "이메일: \(model.email ?? "")"
        labelUserCreatedAt.text = "가입일: \((model.created_at ?? "").split(separator: "T")[0])"
    }
}

