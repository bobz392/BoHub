//
//  UserListViewController.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import RxSwift

class UserListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let userListViewType: UserListViewType
    let userListViewModel: UserListViewModel
    
    public init(
        userListViewType: UserListViewType,
        userListViewModel: UserListViewModel
    ) {
        self.userListViewType = userListViewType
        self.userListViewModel = userListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "BoHub"
        self.userListViewType.addToView(self.view)
        self.bindEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userListViewModel.input.requestNextPage.onNext(.refresh)
    }
    
    // MARK: - binding 
    private func bindEvent() {
        self.userListViewModel.output
            .loading
            .take(2)
            .bind(to: userListViewType.isLoading)
            .disposed(by: disposeBag)
        
        self.userListViewModel.output
            .loading
            .skip(2)
            .bind(to: self.userListViewType.isLoadingMore)
            .disposed(by: disposeBag)
        
        Observable.zip(
            self.userListViewType.userTableViewRx.itemSelected,
            self.userListViewType.userTableViewRx.modelSelected(UserModel.self)
        )
        .bind { [unowned self] indexPath, data in
            self.userListViewType.diselectedUserRow(at: indexPath)
            let detailPage = UserDetailViewController.builder(
                username: data.login,
                serviceProvider: self.userListViewModel.serviceProvider
            )
            let navPage = UINavigationController(rootViewController: detailPage)
            navPage.isNavigationBarHidden = true
            self.navigationController?.present(navPage, animated: true)
        }.disposed(by: disposeBag)
        
        self.userListViewModel.output.usersResult
            .flatMap(self.userListViewModel.mapUserList)
            .subscribe(onNext: { users in
                // error process and something else
            }).disposed(by: disposeBag)
            
        self.userListViewModel.output.users
            .bind(to: self.userListViewType.userTableViewRx.items(
                cellIdentifier: UserListCell.reuseId,
                cellType: UserListCell.self)) { (row, data, cell) in
                    cell.nameLabel.text = data.login
                    cell.siteLabel.text = data.htmlUrl
                    cell.avatarImageView
                        .setNetworkImageUrl(avatarUrl: data.avatarUrl)
                }.disposed(by: disposeBag)
        
        self.userListViewType.willDisplayCell
            .map({ $0.indexPath.row })
            .withLatestFrom(self.userListViewModel.output.users, resultSelector: { ($0, $1)})
            .flatMap(self.userListViewModel.refreshNextPageIfNeed)
            .bind(to: self.userListViewModel.input.requestNextPage)
            .disposed(by: disposeBag)
    }
    
    deinit{
        print("\(self.debugDescription) deinit")
    }
}
