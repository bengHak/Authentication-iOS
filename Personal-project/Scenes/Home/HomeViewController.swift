//
//  HomeViewController.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture

class HomeViewController: UIViewController {
    
    // MARK: - UI Properties
    private let labelHome = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 40)
    }
    
    private let btnUserTab = UIButton().then {
        $0.setTitle("사용자", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
    }
    
    private let btnAdminTab = UIButton().then {
        $0.setTitle("관리자", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
    }
    
    private let stackViewTop = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    private let btnUpdateUsername = UIButton(type: .roundedRect).then {
        $0.setTitle("이름 수정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
    }
    
    private let btnSignout = UIButton(type: .roundedRect).then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    // MARK: - UI Properties
    var bag = DisposeBag()
    var viewModel = HomeViewModel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        configureView()
        bindRx()
        fetchData()
    }
    
    
    // MARK: - Helper
    func fetchData() {
        viewModel.fetchUserProfile()
        viewModel.verifyIsAdminUser()
    }
}

// MARK: - BaseViewController
extension HomeViewController {
    
    func configureView() {
        [btnUserTab, btnAdminTab].forEach {
            stackViewTop.addArrangedSubview($0)
        }
        [btnUpdateUsername, btnSignout].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(stackViewTop)
        view.addSubview(stackView)
        view.addSubview(labelHome)
        
        labelHome.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        stackViewTop.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        stackViewTop.isHidden = true
    }
}


// MARK: - Bindable
extension HomeViewController {
    func bindRx() {
        bindViewModel()
        bindButton()
    }
    
    func bindViewModel() {
        viewModel.output.userProfile
            .subscribe(onNext:{ [weak self] userProfile in
                guard let self = self else { return }
                self.labelHome.text = userProfile?.username ?? "-name error-"
            })
            .disposed(by: bag)
        
        viewModel.dependency.isAdmin
            .subscribe(onNext: { [weak self] isAdmin in
                guard let self = self else { return }
                self.stackViewTop.isHidden = !isAdmin
            })
            .disposed(by: bag)
    }
    
    func bindButton() {
        btnSignout.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.signOut()
                DispatchQueue.main.async {
                    self.setNeedsStatusBarAppearanceUpdate()
                    let navigationController = UINavigationController(rootViewController: SignInViewController())
                    self.view.window?.rootViewController = navigationController
                    self.view.window?.makeKeyAndVisible()
                }
            })
            .disposed(by: bag)
    }
    
}
