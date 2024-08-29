//
//  UserDetailViewType.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// MARK: - UserDetailViewType
public typealias UserDetailViewType = ViewPresentable & UserDetailViewInteroperable

/// UserDetailViewInteroperable
public protocol UserDetailViewInteroperable {
    var reposTableViewRx: Reactive<UITableView> { get }
    
    var isLoading: Binder<Bool> { get }
    
    var avatarUrl: Binder<String?> { get }
    var username: Binder<String?> { get }
    var fullname: Binder<String?> { get }
    var followers: Binder<String?> { get }
    var following: Binder<String?> { get }
    var bio: Binder<String?> { get }
    
    var followersTap: ControlEvent<Void> { get }
}

extension UserDetailViewPresenter: UserDetailViewInteroperable {
    public var reposTableViewRx: Reactive<UITableView> {
        return self.repositoryTableView.rx
    }
    
    public var isLoading: Binder<Bool> {
        return self.loadingView.rx.isAnimating
    }
    
    public var username: Binder<String?> {
        self.headerView.nameLabel.rx.text
    }
    
    public var fullname: Binder<String?> {
        self.headerView.fullnameLabel.rx.text
    }
    
    public var followers: Binder<String?> {
        self.headerView.followersButton.rx.title(for: .normal)
    }
    
    public var following: Binder<String?> {
        self.headerView.followingButton.rx.title(for: .normal)
    }
    
    public var bio: Binder<String?> {
        self.headerView.bioLabel.rx.text
    }
    
    public var followersTap: ControlEvent<Void> {
        self.headerView.followersButton.rx.tap
    }
    
    public var avatarUrl: Binder<String?> {
        self.headerView.avatarImageView.rx.networkImageUrl
    }
}
