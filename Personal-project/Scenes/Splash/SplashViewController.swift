//
//  SplashViewController.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import UIKit
import SnapKit
import Then

class SplashViewController: UIViewController {
    
    // MARK: - UI Properties
    private let labelTitle = UILabel().then {
        $0.text = "인증 과제"
        $0.font = .systemFont(ofSize: 40)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(labelTitle)
        labelTitle.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
}
