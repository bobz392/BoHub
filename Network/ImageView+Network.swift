//
//  ImageView+Network.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

extension Reactive where Base: UIImageView {
    
   public var networkImageUrl: Binder<String?> {
        Binder(base){ (v: UIImageView, avatarUrl: String?) in
            if let avatarUrl = avatarUrl, !avatarUrl.isEmpty,
               let url = URL.init(string: avatarUrl) {
                let resource = KF.ImageResource(downloadURL: url)
                v.kf.setImage(
                    with: resource,
                    placeholder: UIImage(named: "default_icon")
                )
            } else {
                v.image = UIImage(named: "default_icon")
            }
        }
    }
}

extension UIImageView {
    public func setNetworkImageUrl(avatarUrl: String?) {
        if let avatarUrl = avatarUrl, !avatarUrl.isEmpty,
           let url = URL.init(string: avatarUrl) {
            let resource = KF.ImageResource(downloadURL: url)
            self.kf.setImage(
                with: resource,
                placeholder: UIImage(named: "default_icon")
            )
        } else {
            self.image = UIImage(named: "default_icon")
        }
    }
}
