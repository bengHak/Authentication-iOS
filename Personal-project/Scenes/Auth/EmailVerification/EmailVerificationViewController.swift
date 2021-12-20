//
//  EmailVerificationViewController.swift
//  Personal-project
//
//  Created by bhakko-MN on 2021/12/20.
//

import UIKit
import SnapKit
import Then
import RxSwift

/*
 1. 이메일과 코드를 보내기
 2. 인증 완료시 홈 화면으로 보내기 (switch)
 3. 인증 실패시 다시 회원가입 페이지로 보내기 (pop)
 */

class EmailVerificationViewController: UIViewController {
    
    // MARK: - UI Properties
    private let labelTitle = UILabel().then {
        $0.text = "이메일 인증"
        $0.font = .systemFont(ofSize: 40)
    }
    
    private let labelEmail = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 24)
    }
    
    private let stackEmail = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let labelCountDown = UILabel().then {
        $0.text = "180초 남았습니다"
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let labelVerificationSuccess = UILabel().then {
        $0.text = "인증에 성공하셨습니다."
        $0.font = .systemFont(ofSize: 40)
        $0.textColor = .systemBlue
        $0.isHidden = true
    }
    
    private let stackCode = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let textFieldVerifyEmail = UITextField().then {
        $0.placeholder = "인증코드를 입력해주세요"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
    }
    
    private let buttonVerifyEmailConfirm = UIButton().then {
        $0.setTitle("인증완료", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 4
    }
    
    private let buttonSignUp = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    // MARK: - Properties
    let bag = DisposeBag()
    let viewModel = EmailVerificationViewModel()
    
    let email: String
    let username: String
    let password: String
    
    var counter: Int = 180
    var timer: Timer?
    
    // MARK: - Lifecycle
    init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        labelEmail.text = email
        
        configureView()
        bind()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(updateCounter),
                             userInfo: nil,
                             repeats: true)
    }
    
    
    // MARK: - Helpers
    @objc func updateCounter() {
        if counter > 0 {
            counter -= 1
            labelCountDown.text = "\(counter)초 남았습니다"
            labelCountDown.textColor = .red
        } else {
            showAlert(message: "입력 시간이 초과되었습니다.")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - BaseViewController
extension EmailVerificationViewController {
    func configureView() {
        view.addSubview(labelTitle)
        stackEmail.addArrangedSubview(labelEmail)
        view.addSubview(stackEmail)
        view.addSubview(textFieldVerifyEmail)
        stackCode.addArrangedSubview(textFieldVerifyEmail)
        stackCode.addArrangedSubview(buttonVerifyEmailConfirm)
        view.addSubview(labelCountDown)
        view.addSubview(stackCode)
        view.addSubview(buttonSignUp)
        view.addSubview(labelVerificationSuccess)
        
        labelTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        stackEmail.snp.makeConstraints {
            $0.top.equalTo(labelTitle.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        buttonVerifyEmailConfirm.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        stackCode.snp.makeConstraints {
            $0.top.equalTo(stackEmail.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        labelCountDown.snp.makeConstraints {
            $0.top.equalTo(stackCode.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        labelVerificationSuccess.snp.makeConstraints {
            $0.top.equalTo(labelCountDown).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        buttonSignUp.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}

// MARK: - Bindable ViewController
extension EmailVerificationViewController {
    
    func bind() {
        bindTextField()
        bindViewModel()
        bindButton()
    }
    
    func bindTextField() {
        textFieldVerifyEmail.rx.text.orEmpty
            .subscribe(onNext: { [weak self] code in
                self?.viewModel.input.code = code
            })
            .disposed(by: bag)
    }
    
    func bindViewModel() {
        viewModel.output.isVerified
            .subscribe(onNext: { [weak self] isVerified in
                guard let self = self else { return }
                if isVerified {
                    self.labelVerificationSuccess.isHidden = false
                    self.buttonVerifyEmailConfirm.isEnabled = false
                    self.textFieldVerifyEmail.isUserInteractionEnabled = false
                    self.buttonSignUp.isEnabled = true
                    self.timer?.invalidate()
                }
            })
            .disposed(by: bag)
        
        viewModel.output.isSignedUp
            .subscribe(onNext: {[weak self] isSignedUp in
                guard let self = self else { return }
                if isSignedUp {
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
    
    func bindButton() {
        buttonVerifyEmailConfirm.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.verifyCode(email: self.email, code: self.viewModel.input.code)
            })
            .disposed(by: bag)
        
        buttonSignUp.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if self.viewModel.output.isVerified.value {
                    self.viewModel.signUp(email: self.email, username: self.username, password: self.password)
                } else {
                    self.showAlert(message: "인증이 완료되지 않았습니다.")
                }
                
            })
            .disposed(by: bag)
    }
}
