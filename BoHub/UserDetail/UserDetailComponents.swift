//
//  UserDetailComponents.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import RxSwift

// MARK: - Detail Header View
class UserDetailHeaderView: UIView {
    
    let avatarImageView: UIImageView = {
        let imv = UIImageView()
        imv.clipsToBounds = true
        imv.layer.borderWidth = 2
        imv.layer.cornerRadius = 40
        imv.layer.borderColor = UIColor.lightGray.cgColor
        return imv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .dms_black
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    let fullnameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .dms_lightBlack
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return lbl
    }()
    
    let followersButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        configuration.titleTextAttributesTransformer = 
        UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 12, weight: .regular)
                return outgoing
            }
        let handler: UIButton.ConfigurationUpdateHandler = { button in
            button.backgroundColor = .clear
        }
        
        let btn = UIButton(configuration: configuration)
        btn.configurationUpdateHandler = handler
        btn.setTitleColor(.dms_black, for: .normal)
        btn.setTitleColor(.dms_lightBlack, for: .highlighted)
        return btn
    }()
    
    let followingButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0
        )
        configuration.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 12, weight: .regular)
                return outgoing
            }
        let handler: UIButton.ConfigurationUpdateHandler = { button in
            button.backgroundColor = .clear
        }
        
        let btn = UIButton(configuration: configuration)
        btn.configurationUpdateHandler = handler
        btn.setTitleColor(.dms_black, for: .normal)
        btn.setTitleColor(.dms_lightBlack, for: .highlighted)
        return btn
    }()
    
    let bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .dms_black
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return lbl
    }()
    
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .dms_white
        self.addSubview(self.avatarImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.fullnameLabel)
        self.addSubview(self.followersButton)
        self.addSubview(self.followingButton)
        self.addSubview(self.bioLabel)
        
        self.avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(40)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.avatarImageView.snp.right).offset(24)
            make.top.equalTo(self.avatarImageView.snp.top).offset(4)
            make.right.equalToSuperview().inset(10)
        }
        
        self.fullnameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.left.right.equalTo(self.nameLabel)
        }
        
        self.followersButton.snp.makeConstraints { make in
            make.top.equalTo(self.fullnameLabel.snp.bottom).offset(8)
            make.left.equalTo(self.nameLabel)
        }
        
        self.followingButton.snp.makeConstraints { make in
            make.top.equalTo(self.followersButton)
            make.left.equalTo(self.followersButton.snp.right).offset(10)
        }
        
        let splitView = UIView()
        splitView.backgroundColor = .dms_lightBlack
        self.addSubview(splitView)
        splitView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(self.followersButton).offset(-3)
            make.centerY.equalTo(self.followersButton)
            make.left.equalTo(self.followersButton.snp.right).offset(4.5)
        }
        
        self.bioLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Repository Cell
class RepositoryCell: UITableViewCell {
    public static let reuseId = "kRepositoryCell"
        
    var disposeBag = DisposeBag()
    
    let cardView: UIView = {
       let v = UIView()
        v.clipsToBounds = true
        v.layer.cornerRadius = 8.0
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lightText.cgColor
        return v
    }()
    
    let publicLabel: UILabel = {
        let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 10
        lbl.layer.borderColor = UIColor.lightText.cgColor
        lbl.layer.borderWidth = 1
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lbl.textAlignment = .center
        lbl.textColor = .lightText
        return lbl
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.clipsToBounds = true
        lbl.textColor = .dms_brandBlue
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lbl
    }()
    
    let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 5
        lbl.textColor = .dms_lightBlack
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()
    
    let languageView: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.layer.cornerRadius = 8
        return v
    }()
    let languageLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 5
        lbl.textColor = .dms_lightBlack
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()
    
    let starImage: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "star")
        imv.tintColor = .dms_lightBlack
        return imv
    }()
    
    let starLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .dms_lightBlack
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .dms_white
        self.contentView.addSubview(self.cardView)
        self.cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
        self.cardView.addSubview(publicLabel)
        self.cardView.addSubview(nameLabel)
        self.cardView.addSubview(descriptionLabel)
        self.cardView.addSubview(languageView)
        self.cardView.addSubview(languageLabel)
        self.cardView.addSubview(starImage)
        self.cardView.addSubview(starLabel)
        self.accessoryType = .none

        self.publicLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(15)
            make.width.equalTo(70)
            make.right.equalToSuperview().inset(20)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(publicLabel)
            make.right.equalTo(self.publicLabel.snp.left).offset(-20)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(15)
        }
        
        self.languageView.snp.makeConstraints { make in
            make.left.equalTo(self.descriptionLabel)
            make.width.height.equalTo(16)
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(15)
        }
        self.languageLabel.snp.makeConstraints { make in
            make.left.equalTo(self.languageView.snp.right).offset(4)
            make.centerY.equalTo(self.languageView)
        }
        
        self.starImage.snp.makeConstraints { make in
            make.left.equalTo(self.languageLabel.snp.right).offset(24)
            make.centerY.equalTo(self.languageView)
            make.width.height.equalTo(14)
        }
        self.starLabel.snp.makeConstraints { make in
            make.left.equalTo(self.starImage.snp.right).offset(4)
            make.centerY.equalTo(self.languageView)
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
