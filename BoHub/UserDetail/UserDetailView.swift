//
//  UserDetailView.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import SnapKit

// MARK: - User List View
public struct UserDetailViewPresenter: ViewPresentable {
    
    let headerView = UserDetailHeaderView()
    let repositoryTableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .plain)
        tbv.separatorStyle = .none
        tbv.keyboardDismissMode = .onDrag
        tbv.estimatedRowHeight = 74
        tbv.backgroundColor = .dms_white
        return tbv
    }()
    
    let loadingView: UIActivityIndicatorView = {
        let lv = UIActivityIndicatorView(style: .large)
        lv.hidesWhenStopped = true
        return lv
    }()
    
    private func buildUI(rootView: UIView) {
        rootView.addSubview(self.repositoryTableView)
        
        self.repositoryTableView.register(
            RepositoryCell.self,
            forCellReuseIdentifier: RepositoryCell.reuseId
        )
        self.repositoryTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(rootView.safeAreaInsets.top)
            make.bottom.equalTo(rootView.safeAreaInsets.bottom)
        }
       
        self.repositoryTableView.tableHeaderView = headerView
        self.headerView.snp.makeConstraints { make in
            make.left.right.equalTo(self.repositoryTableView)
            make.width.equalTo(self.repositoryTableView)
        }
        
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

