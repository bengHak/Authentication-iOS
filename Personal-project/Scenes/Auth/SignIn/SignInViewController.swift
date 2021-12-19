//
//  SignInViewController.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import UIKit
import SnapKit
import Then

class SignInViewController: UIViewController {
    
    // MARK: - UI Properties
    private let labelSignin = UILabel().then {
        $0.text = "로그인 뷰"
        $0.font = .systemFont(ofSize: 40)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureView()
    }

}

// MARK: - BaseViewController
extension SignInViewController {
    func configureView() {
        view.addSubview(labelSignin)
        
        labelSignin.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
