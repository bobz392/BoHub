//
//  ViewPresentable.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import Foundation

import UIKit

// MARK: - view presentable
public protocol ViewPresentable {
    func addToView(_ rootView: UIView)
    func buildPhoneUI(_ rootView: UIView)
    func buildPadUI(_ rootView: UIView)
    
    func safeareaDidChange(_ rootView: UIView)
    func removeView()
}

public extension ViewPresentable {
    
    func addToView(_ rootView: UIView) {
        if self.deviceIsPhone {
            buildPhoneUI(rootView)
        } else {
            buildPadUI(rootView)
        }
     }
    
    var deviceIsPhone: Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == .phone
        }
    }
    
    func buildPhoneUI(_ rootView: UIView) {}
    func buildPadUI(_ rootView: UIView) {}
    
    func removeView() {
        #if DEBUG
        print("\(type(of: self)) cant remove")
        #endif
    }
    
    func safeareaDidChange(_ rootView: UIView) {}
    
    var screenWidth: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
            return windowScene.screen.bounds.width
        } else {
            return 0
        }
    }
}
