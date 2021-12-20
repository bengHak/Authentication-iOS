//
//  SignInViewController.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/17.
//

import UIKit
import SnapKit
import Then
import RxSwift

class SignInViewController: UIViewController {
    
    // MARK: - UI Properties
    private let labelSignin = UILabel().then {
        $0.text = "로그인"
        $0.font = .systemFont(ofSize: 40)
    }

    // email 입력 필드
    private let textFieldEmail = UITextField().then {
        $0.placeholder = "이메일을 입력하세요"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .emailAddress
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
    }

    // password 입력 필드
    private let textFieldPassword = UITextField().then {
        $0.placeholder = "비밀번호를 입력하세요"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
    }

    // 로그인 버튼
    private let buttonSignin = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 10
    }

    // 회원가입 버튼
    private let buttonSignup = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.layer.cornerRadius = 10
    }

    // MARK: - Properties
    var bag = DisposeBag()
    var viewModel = SignInViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureView()
        bindRx()
    }

}

// MARK: - BaseViewController
extension SignInViewController {
    func configureView(){
        view.addSubview(labelSignin)
        view.addSubview(textFieldEmail)
        view.addSubview(textFieldPassword)
        view.addSubview(buttonSignin)
        view.addSubview(buttonSignup)
        
        labelSignin.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        textFieldEmail.snp.makeConstraints {
            $0.top.equalTo(labelSignin.snp.bottom).offset(100)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
        
        textFieldPassword.snp.makeConstraints {
            $0.top.equalTo(textFieldEmail.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
        
        buttonSignin.snp.makeConstraints {
            $0.top.equalTo(textFieldPassword.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
        
        buttonSignup.snp.makeConstraints {
            $0.top.equalTo(buttonSignin.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
    }
}


// MARK: - BindableViewController
extension SignInViewController {
    func bindRx() {
        bindFields()
        bindButtons()
        bindSignIn()
    }
    
    func bindFields() {
        textFieldEmail.rx.text.orEmpty
            .subscribe(onNext: { [weak self] email in
                self?.viewModel.input.email = email
            })
            .disposed(by: bag)
        
        textFieldPassword.rx.text.orEmpty
            .subscribe(onNext: { [weak self] password in
                self?.viewModel.input.password = password
            })
            .disposed(by: bag)
    }
    
    func bindButtons() {
        buttonSignin.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signIn()
            })
            .disposed(by: bag)

        buttonSignup.rx.tap
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(SignUpViewController(), animated: true)
                }
            })
            .disposed(by: bag)
    }
    
    func bindSignIn() {
        viewModel.output.isSignedIn
            .subscribe(onNext: { [weak self] isSigned in
                guard let self = self else { return }
                if isSigned {
                    DispatchQueue.main.async {
                        self.setNeedsStatusBarAppearanceUpdate()
                        let navigationController = UINavigationController(rootViewController: HomeViewController())
                        self.view.window?.rootViewController = navigationController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            })
            .disposed(by: bag)
    }
}
