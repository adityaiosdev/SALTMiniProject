//
//  HomeViewController.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    var userItemList: [UserItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Home SALT Mini Project"
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.textColor = UIColor.blue
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return welcomeLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        view.backgroundColor = UIColor.white
        viewModel.getUserDetails()
        layoutViews()
    }
    
    func bindViewModel() {
        viewModel.userItemsObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] userItemList in
                guard let self = self else { return }
                self.userItemList = userItemList
            })
            .disposed(by: disposeBag)
    }
    
    func layoutViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            tableView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        cell.build(data: self.userItemList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
