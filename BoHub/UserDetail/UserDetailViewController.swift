//
//  UserDetailViewController.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import SafariServices

import RxSwift

extension UserDetailViewController {
    static func builder(
        username: String,
        serviceProvider: ServiceProviderType
    ) -> UserDetailViewController {
        let viewmodel = UserDetailViewModel(serviceProvider: serviceProvider)
        return UserDetailViewController(
            username: username,
            userDetailViewType: UserDetailViewPresenter(),
            userDetailViewModel: viewmodel
        )
    }
}

class UserDetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let userDetailViewType: UserDetailViewType
    let userDetailViewModel: UserDetailViewModel
    let username: String
    
    public init(
        username: String,
        userDetailViewType: UserDetailViewType,
        userDetailViewModel: UserDetailViewModel
    ) {
        self.username = username
        self.userDetailViewType = userDetailViewType
        self.userDetailViewModel = userDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.userDetailViewType.addToView(self.view)
        self.bindEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Observable.just(username)
            .bind(to: self.userDetailViewModel.input.requestUserDetail)
            .disposed(by: disposeBag)
    }
    
    // MARK: - binding
    private func bindEvent() {
        self.userDetailViewModel.output
            .loading
            .bind(to: self.userDetailViewType.isLoading)
            .disposed(by: disposeBag)
        
        let userDetail = self.userDetailViewModel.output
            .userDetailResult
            .flatMap(self.userDetailViewModel.mapDetailModel)
            .share(replay: 1)
        
        userDetail.map { $0.login }
            .bind(to: self.userDetailViewType.username)
            .disposed(by: disposeBag)
        
        userDetail.map { $0.name }
            .bind(to: self.userDetailViewType.fullname)
            .disposed(by: disposeBag)
        
        userDetail.map { "\($0.followers) followers" }
            .bind(to: self.userDetailViewType.followers)
            .disposed(by: disposeBag)
        
        userDetail.map { "\($0.following) following" }
            .bind(to: self.userDetailViewType.following)
            .disposed(by: disposeBag)
        
        userDetail.map { $0.bio }
            .bind(to: self.userDetailViewType.bio)
            .disposed(by: disposeBag)
        
        userDetail.map { $0.avatarUrl }
            .bind(to: self.userDetailViewType.avatarUrl)
            .disposed(by: disposeBag)
        
        self.userDetailViewModel.output.repositoriesResult
            .flatMapLatest(self.userDetailViewModel.mapRepositories)
            .bind(to: self.userDetailViewType.reposTableViewRx.items(
                cellIdentifier: RepositoryCell.reuseId,
                cellType: RepositoryCell.self
            )) { [unowned self] (row, data, cell) in
                cell.nameLabel.text = data.name
                cell.descriptionLabel.text = data.description
                cell.publicLabel.text = data.private ? "Private" : "Public"
                if let lang = data.language {
                    cell.languageView.backgroundColor = self.colorFromString(
                        lang
                    )
                    cell.languageLabel.text = lang
                } else {
                    cell.languageView.backgroundColor = self.colorFromString(
                        "Unknown"
                   )
                   cell.languageLabel.text = "Unknown"
                }
                cell.starLabel.text = "\(data.stargazersCount)"
            }.disposed(by: disposeBag)
        
        Observable.zip(
            self.userDetailViewType.reposTableViewRx.itemSelected,
            self.userDetailViewType
                .reposTableViewRx.modelSelected(RepositoryModel.self)
        )
        .bind { [unowned self] indexPath, data in
            guard let url = URL(string: data.htmlUrl)
            else { return }
            let safariPage = SFSafariViewController(url: url)
            safariPage.dismissButtonStyle = .done
            safariPage.delegate = self
            self.navigationController?.pushViewController(safariPage, animated: true)
        }.disposed(by: disposeBag)
        
//        self.userDetailViewType.followersTap
//            .subscribe(onNext: { [unowned self] _ in
//        }).disposed(by: disposeBag)
    }
    
    private func colorFromString(_ input: String) -> UIColor {
        guard input.count >= 3 else {
            return UIColor.cyan
        }
        let firstThreeLetters = input.prefix(3).lowercased()
        let asciiValues: [UInt16] = firstThreeLetters
            .map { UInt16($0.asciiValue ?? 0) }
        let red = CGFloat(asciiValues[0] * 7 % 256) / 255.0
        let green = CGFloat(asciiValues[1] * 5 % 256) / 255.0
        let blue = CGFloat(asciiValues[2] * 4 % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UserDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.navigationController?.dismiss(animated: true)
    }
}
