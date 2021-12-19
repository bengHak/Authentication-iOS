//
//  HomeViewController.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import UIKit
import SnapKit
import Then

class HomeViewController: UIViewController {
    
    // MARK: - UI Properties
    private let labelHome = UILabel().then {
        $0.text = "kajsdlfj"
        $0.font = .systemFont(ofSize: 40)
    }
    
    private let btnUpdateUsername = UIButton().then {
        $0.setTitle("이름 수정", for: .normal)
    }
    
    private let btnSignout = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        configureView()
    }

}

// MARK: - BaseViewController
extension HomeViewController {
    
    func configureView() {
        view.addSubview(labelHome)
        
        labelHome.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
