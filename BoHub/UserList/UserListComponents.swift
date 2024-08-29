//
//  UserListComponents.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import SnapKit
import RxSwift

// MARK: - cell unit
class UserListCell: UITableViewCell {
    
    public static let reuseId = "kUserCell"
        
    var disposeBag = DisposeBag()
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.clipsToBounds = true
        lbl.textColor = .dms_black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return lbl
    }()
    
    let siteLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.clipsToBounds = true
        lbl.textColor = .dms_lightBlack
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    let avatarImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(avatarImageView)
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = 20
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(siteLabel)
        self.accessoryType = .disclosureIndicator

        self.avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.avatarImageView.snp.right).offset(20)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        self.siteLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

