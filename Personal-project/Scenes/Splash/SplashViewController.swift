//
//  SplashViewController.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import UIKit
import SnapKit
import Then
import Alamofire
import SwiftKeychainWrapper

class SplashViewController: UIViewController {
    
    // MARK: - UI Properties
    private let labelTitle = UILabel().then {
        $0.text = "인증 과제"
        $0.font = .systemFont(ofSize: 40)
    }
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifyToken()
    }
    
    // MARK: - Helpers
    func move2ViewController(isSigninNeeded: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        
        var vc: UIViewController
        if isSigninNeeded {
            vc = SignInViewController()
        } else {
            vc = HomeViewController()
        }
        
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
    }
    
    func verifyToken() {
        let apiRequest = APIRequest()
        apiRequest.getUserProfile(handler: { [weak self] (success) in
            switch success {
            case .success(_):
                self?.move2ViewController(isSigninNeeded: false)
            case .failure(_):
                self?.move2ViewController(isSigninNeeded: true)
            }
        })
    }
}

// MARK: - BaseViewController
extension SplashViewController {
    
    func configureView() {
        view.addSubview(labelTitle)
        labelTitle.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
}
