//
//  UserListViewType.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// MARK: - UserListViewType
public typealias UserListViewType = ViewPresentable & UserListViewInteroperable

/// UserListViewInteroperable
public protocol UserListViewInteroperable {
    var userTableViewRx: Reactive<UITableView> { get }
    var willDisplayCell: ControlEvent<WillDisplayCellEvent> { get }
    var isLoading: Binder<Bool> { get }
    var isLoadingMore: Binder<Bool> { get }
    func diselectedUserRow(at: IndexPath)
}

extension UserListViewPresenter: UserListViewInteroperable {
   
    public var userTableViewRx: RxSwift.Reactive<UITableView> {
        return self.userTableView.rx
    }
    
    public var willDisplayCell: ControlEvent<WillDisplayCellEvent> {
        self.userTableView.rx.willDisplayCell
    }
    
    public var isLoading: Binder<Bool> {
        return self.loadingView.rx.isAnimating
    }
    
    public var isLoadingMore: Binder<Bool> {
        return self.footerIndicator.rx.isAnimating
    }
    
    public func diselectedUserRow(at: IndexPath) {
        self.userTableView.deselectRow(at: at, animated: true)
    }
}

