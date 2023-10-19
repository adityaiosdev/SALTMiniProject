//
//  RegisterViewController.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    
    private var viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Selamat Datang di SALT Mini Project"
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.numberOfLines = 2
        welcomeLabel.textColor = UIColor.blue
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return welcomeLabel
    }()
    
    lazy var directionLabel: UILabel = {
        let directionLabel = UILabel()
        directionLabel.text = "Silahkan Login"
        directionLabel.translatesAutoresizingMaskIntoConstraints = false
        directionLabel.numberOfLines = 1
        directionLabel.textColor = UIColor.black
        directionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return directionLabel
    }()
    
    lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Masukkan Email..."
        emailTextField.setLeftPaddingPoints(20)
        emailTextField.setRightPaddingPoints(20)
        emailTextField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        emailTextField.layer.cornerRadius = 6
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        return emailTextField
    }()
    
    lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Masukkan Password..."
        passwordTextField.setLeftPaddingPoints(20)
        passwordTextField.setRightPaddingPoints(20)
        passwordTextField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        passwordTextField.layer.cornerRadius = 6
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 6
        loginButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        return loginButton
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .gray
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        layoutViews()
    }
    
    func bindViewModel() {
        viewModel.tokenObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] token in
                guard let self = self else { return }
                guard token.error == nil else {
                    self.showAlert(title: "User tidak ditemukan", message: "Silahkan coba lagi")
                    return }
                self.routeToHomeViewController()
            })
            .disposed(by: disposeBag)
        
        viewModel.stateObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .invalidEmail:
                    loadingIndicator.stopAnimating()
                    self.showAlert(title: "Email tidak valid", message: "Silahkan coba lagi")
                case .loading:
                    loadingIndicator.startAnimating()
                case .loaded:
                    loadingIndicator.stopAnimating()
                case .error(let message):
                    self.showAlert(title: "Terjadi Kesalahan", message: "Silahkan coba lagi")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func routeToHomeViewController() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    @objc func loginButtonTapped() {
        viewModel.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    func layoutViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(directionLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            directionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            directionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            directionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            emailTextField.topAnchor.constraint(equalTo: directionLabel.bottomAnchor, constant: 30),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 45),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
