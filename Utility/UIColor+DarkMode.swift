//
//  UIColor+DarkMode.swift
//  BoHub
//
//  Created by Bob Zhou on 2024/8/29.
//

import UIKit

// MARK: - Color Dark Mode Support
public extension UIColor {
    
    class func alphaBlack(_ alpha: CGFloat) -> UIColor {
        return UIColor.black.withAlphaComponent(alpha)
    }
    
    class func alphaWhite(_ alpha: CGFloat) -> UIColor {
        return UIColor.white.withAlphaComponent(alpha)
    }
    
    /// white alpha 0.1
    class func backgroundWhite() -> UIColor {
        return UIColor.white.withAlphaComponent(0.1)
    }
    
    /// white alpha 0.1
    class func maskBlack() -> UIColor {
        return UIColor.white.withAlphaComponent(0.9)
    }
    
    /// white alpha 0.1
    class func maskWhite() -> UIColor {
        return UIColor.white.withAlphaComponent(0.9)
    }
    
    class func dms_color(dark: UIColor,
                         light: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        } else {
            return light
        }
    }
    
    class func dms_hexColor(darkHex: UInt,
                            lightHex: UInt) -> UIColor {
        return UIColor.dms_color(dark: UIColor(hex: darkHex),
                                 light: UIColor(hex: lightHex))
    }

    class func dms_hexColor(darkHex: UInt, darkAlpha: CGFloat,
                            lightHex: UInt, lightAlpha: CGFloat) -> UIColor {
        return UIColor
            .dms_color(dark: UIColor(hex: darkHex, alpha: darkAlpha),
                       light:  UIColor(hex: lightHex, alpha: lightAlpha))
    }
    
    // MARK: convince color variable
    class var dms_white: UIColor {
        return UIColor.dms_hexColor(darkHex: 0x000000, lightHex: 0xffffff)
    }
    
    class var dms_black: UIColor {
        return UIColor.dms_hexColor(darkHex: 0xffffff, lightHex: 0x000000)
    }
    
    class var dms_lightBlack: UIColor {
        return UIColor.dms_color(dark: .white.withAlphaComponent(0.6), light: .black.withAlphaComponent(0.6))
    }
    
    /// 0xFFE607
    class var dms_warning: UIColor {
        return UIColor.dms_hexColor(darkHex: 0xFFE607, lightHex: 0xFFE607)
    }
    
    /// 0x0068B0
    class var dms_brandBlue: UIColor {
        let hexColor = color(hex: 0x0068B0)
        return .dms_color(dark: hexColor, light: hexColor)
    }
    
    /// 0xED3F34
    class var dms_alert: UIColor {
        let color = UIColor(hex: 0xED3F34)
        return .dms_color(dark: color, light: color)
    }
    
    // MARK: - darkmode
    class var dms_darkMode: Bool {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return true
            }
        }
        return false
    }
    
}

// MARK: - Image & ImageView & Button Dark Mode Support
public extension UIImage {
    
    func dms_image() -> (UIImage, Bool) {
        if UIColor.dms_darkMode {
            return (withRenderingMode(.alwaysTemplate), true)
        } else {
            return (withRenderingMode(.alwaysTemplate), false)
        }
    }
}

public extension UIImageView {
    
    func dms_setImage(image: UIImage?,
                      lightTint: UIColor = .white,
                      darkTint: UIColor = .black) {
        guard let image = image else { return }
        let (dmsImage, inDarkMode) = image.dms_image()
        self.image = dmsImage
        if inDarkMode {
            self.tintColor = darkTint
        } else {
            self.tintColor = lightTint
        }
    }
    
    func dms_setImage(light: UIImage?, dark: UIImage?) {
        if UIColor.dms_darkMode {
            self.image = dark
        } else {
            self.image = light
        }
    }
}

public extension UIButton {
    
    func dms_setImage(_ image: UIImage?, for state: UIControl.State,
                      lightTint: UIColor = .white,
                      darkTint: UIColor = .black) {
        guard let image = image else { return }
        let (dmsImage, inDarkMode) = image.dms_image()
        self.setImage(dmsImage, for: state)
        if inDarkMode {
            self.tintColor = darkTint
        } else {
            self.tintColor = lightTint
        }
    }
    
}

public extension UIColor {
 
  convenience init(hex: UInt, alpha: CGFloat = 1.0) {
    let red = CGFloat((hex & Red.mask) >> Red.rightShift) / UIColor.maxInByte
    let green = CGFloat((hex & Green.mask) >> Green.rightShift) / UIColor.maxInByte
    let blue = CGFloat((hex & Blue.mask) >> Blue.rightShift) / UIColor.maxInByte

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  @objc
  static func color(hex: UInt, alpha: CGFloat) -> UIColor {
    UIColor(hex: hex, alpha: alpha)
  }

  @objc
  static func color(hex: UInt) -> UIColor {
    UIColor(hex: hex)
  }
}

private extension UIColor {
  enum Red {
    static let mask: UInt = 0xFF0000
    static let rightShift = 16
  }

  enum Green {
    static let mask: UInt = 0x00FF00
    static let rightShift = 8
  }

  enum Blue {
    static let mask: UInt = 0x0000FF
    static let rightShift = 0
  }

  static let maxInByte = CGFloat(0xFF)
}

