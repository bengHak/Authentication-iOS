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
import RxCocoa
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

    private let tableView = UITableView().then {
        $0.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        $0.rowHeight = 130
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

    func showUpdateUsernameAlert() {
        let alert = UIAlertController(title: "이름 수정", message: "수정할 이름을 입력하세요", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "이름을 입력하세요"
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            guard let textField = alert.textFields?.first else { return }
            self.viewModel.updateUsername(username: textField.text ?? "")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showUpdateAdminUsernameAlert(userId: Int, username: String) {
        let alert = UIAlertController(title: "\(username)님의 유저네임 수정", message: "수정할 이름을 입력하세요", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "이름을 입력하세요"
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            guard let textField = alert.textFields?.first else { return }
            self.viewModel.updateUsernameWithAdmin(userId: userId, username: textField.text ?? "")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showUserDeleteAlert(userId: Int, username: String) {
        let alert = UIAlertController(title: "\(username)님 삭제", message: "사용자를 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.deleteUser(userId: userId)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showUpdateAuthorityActionSheet(userId: Int) {
        let alert = UIAlertController(title: "권한 수정", message: "권한을 선택하세요", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "관리자", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.updateAuthority(userId: userId, authority: .admin)
        }))
        alert.addAction(UIAlertAction(title: "사용자", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.updateAuthority(userId: userId, authority: .user)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
        view.addSubview(tableView)
        
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

        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(stackViewTop.snp.bottom)
            $0.bottom.equalTo(stackView.snp.top)
        }
        tableView.isHidden = true
    }
}


// MARK: - Bindable
extension HomeViewController {
    func bindRx() {
        bindViewModel()
        bindTable()
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
    
    func bindTable() {
        viewModel.output.userList
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: tableView.rx.items(cellIdentifier: UserTableViewCell.identifier, cellType: UserTableViewCell.self)) { [weak self] (row, user, cell) in
                guard let self = self else { return }
                cell.setData(model: user)
                cell.selectionStyle = .none
                
                guard let userId = user.id,
                      let username = user.username else {
                          return
                      }
                
                cell.delegate = self
            }
            .disposed(by: bag)
    }
    
    func bindButton() {
        btnUserTab.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = true
                self.labelHome.isHidden = false
            }) 
            .disposed(by: bag)
        
        btnAdminTab.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = false
                self.labelHome.isHidden = true
            })
            .disposed(by: bag)

        btnUpdateUsername.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showUpdateUsernameAlert()
            })
            .disposed(by: bag)

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

// MARK: - UserTableCellDelegate
extension HomeViewController: UserTableCellDelegate {
    func updateAdminUsername(userId: Int, username: String) {
        print("update admin username: \(userId), \(username)")
        showUpdateAdminUsernameAlert(userId: userId, username: username)
    }
    
    func deleteUser(userId: Int, username: String) {
        print("delete user: \(userId)")
        showUserDeleteAlert(userId: userId, username: username)
    }
    
    func updateAuthority(userId: Int) {
        showUpdateAuthorityActionSheet(userId: userId)
    }
    
}
