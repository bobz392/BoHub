//
//  UserListView.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import SnapKit

// MARK: - User List View
public struct UserListViewPresenter: ViewPresentable {
    let userTableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .plain)
        tbv.keyboardDismissMode = .onDrag
        tbv.rowHeight = 74
        tbv.estimatedRowHeight = 74
        tbv.backgroundColor = .dms_white
        return tbv
    }()
    
    let loadingView: UIActivityIndicatorView = {
        let lv = UIActivityIndicatorView(style: .large)
        lv.hidesWhenStopped = true
        return lv
    }()
    
    let footerIndicator = UIActivityIndicatorView(style: .medium)
    
    private func buildUI(rootView: UIView) {
        rootView.addSubview(self.userTableView)
        self.userTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(rootView.safeAreaInsets.top)
            make.bottom.equalTo(rootView.safeAreaInsets.bottom)
        }
        
        self.userTableView.register(
            UserListCell.self,
            forCellReuseIdentifier: UserListCell.reuseId
        )
        
        let footView = UIView()
        footView.backgroundColor = .dms_white
        
        footView.addSubview(footerIndicator)
        footerIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.userTableView.tableFooterView = footView
        footView.frame = CGRect(
            origin: .zero,
            size: .init(width: self.userTableView.frame.width, height: 44)
        )
        
        rootView.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func buildPadUI(_ rootView: UIView) {
        self.buildUI(rootView: rootView)
    }
    
    public func buildPhoneUI(_ rootView: UIView) {
        self.buildUI(rootView: rootView)
    }
}
