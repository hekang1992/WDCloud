//
//  Extensions.swift
//  问道云
//
//  Created by Andrew on 2025/3/10.
//  拓展

import UIKit

extension Double {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension CGFloat {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension Int {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

//颜色
extension UIColor {
    convenience init?(cssStr: String) {
        let hexString = cssStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard hexString.hasPrefix("#") else {
            return nil
        }
        let hexCode = hexString.dropFirst()
        guard hexCode.count == 6, let rgbValue = UInt64(hexCode, radix: 16) else {
            return nil
        }
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func random() -> UIColor {
        return UIColor(red: randomNumber(),
                       green: randomNumber(),
                       blue: randomNumber(),
                       alpha: 1.0)
    }
    
    private class func randomNumber() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
}

extension UIView {
    
    func removeAllSubviews() {
        while let subview = self.subviews.first {
            subview.removeFromSuperview()
        }
    }
    
    func setTopCorners(radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }
}

//字体
extension UIFont {
    class func regularFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .regular)
    }
    
    class func mediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .medium)
    }
    
    class func boldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .bold)
    }
    
    class func semiboldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.pix(), weight: .semibold)
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let location = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let offset = CGPoint(
            x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let adjustedLocation = CGPoint(x: location.x - offset.x, y: location.y - offset.y)
        
        let index = layoutManager.characterIndex(for: adjustedLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(index, targetRange)
    }
}

//按钮图片和文字的位置
enum ButtonEdgeInsetsStyle {
    case top // image in top，label in bottom
    case left  // image in left，label in right
    case bottom  // image in bottom，label in top
    case right // image in right，label in left
}

extension UIButton {
    func layoutButtonEdgeInsets(style: ButtonEdgeInsetsStyle, space: CGFloat) {
        setNeedsLayout()
        layoutIfNeeded()
        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0
        var imageEdgeInset = UIEdgeInsets.zero
        var labelEdgeInset = UIEdgeInsets.zero
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        labelWidth = min(labelWidth, frame.width - space - imageWith!)
        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        
        switch style {
        case .top:
            if ((self.titleLabel?.intrinsicContentSize.width ?? 0) + (imageWith ?? 0)) > frame.width {
                let imageOffsetX = (frame.width - imageWith!) / 2
                imageEdgeInset = UIEdgeInsets(top: -labelHeight - space / 2.0, left: imageOffsetX, bottom: 0, right: -imageOffsetX)
            } else {
                imageEdgeInset = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            }
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith!, bottom: -imageHeight! - space / 2.0, right: 0)
        case .left:
            imageEdgeInset = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            labelEdgeInset = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
        case .bottom:
            imageEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInset = UIEdgeInsets(top: -imageHeight! - space / 2.0, left: -imageWith!, bottom: 0, right: 0)
        case .right:
            imageEdgeInset = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith! - space / 2.0, bottom: 0, right: imageWith! + space / 2.0)
        }
        self.titleEdgeInsets = labelEdgeInset
        self.imageEdgeInsets = imageEdgeInset
    }
}

//图片拓展
extension UIImage {
    class func imageOfText(_ text: String,
                           size: (CGFloat, CGFloat),
                           bgColor: UIColor = .random(),
                           textColor: UIColor = .white,
                           cornerRadius: CGFloat = 5) -> UIImage? {
        // 过滤空""
        if text.isEmpty { return nil }
        // 取第一个字符
        let letter = (text as NSString).substring(to: 1)
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(sise, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if cornerRadius > 0 {
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(bgColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        
        let attr = [
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.font : UIFont.boldFontOfSize(size: minSide * 0.6),
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.kern: 0
        ] as [NSAttributedString.Key : Any]
        
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.attributedText = .init(string: letter, attributes: attr)
        textLabel.sizeToFit()
        let textW = textLabel.frame.width
        let textH = textLabel.frame.height
        textLabel.drawText(in: .init(x: minSide / 2 - textW / 2, y: minSide / 2 - textH / 2, width: textW, height: textH))
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    //创建二维码
    class func qrImageForString(qrString: String?, qrImage: UIImage? = nil) -> UIImage? {
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: .utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            // 返回二维码image
            //let codeImage = UIImage(ciImage: colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5)))
            let codeImage = UIImage(ciImage: colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
            
            // 中间都会放想要表达意思的图片
            if let iconImage = qrImage {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width,
                                  height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
}

extension String {
    var removingEmojis: String {
        return self.filter { !$0.isEmoji }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        do {
            let data = Data(self.utf8)
            return try NSAttributedString(data: data, options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
        } catch {
            print("Error converting HTML to attributed string: \(error)")
            return nil
        }
    }
    
}

extension Character {
    var isEmoji: Bool {
        // 判断是否为表情符号
        return (0x1F600...0x1F64F).contains(self.unicodeScalars.first!.value) ||  // Emoticons
        (0x1F300...0x1F5FF).contains(self.unicodeScalars.first!.value) ||  // Misc Symbols and Pictographs
        (0x1F680...0x1F6FF).contains(self.unicodeScalars.first!.value) ||  // Transport and Map
        (0x2600...0x26FF).contains(self.unicodeScalars.first!.value) ||   // Misc symbols
        (0x2700...0x27BF).contains(self.unicodeScalars.first!.value)      // Dingbats
    }
}

//获取当前控制器
extension UIViewController {
    class func getCurrentViewController() -> UIViewController {
        let rootVc = keyWindow?.rootViewController
        let currentVc = getCurrentViewController(rootVc!)
        return currentVc
    }
    
    class func getCurrentViewController(_ rootVc: UIViewController) -> UIViewController {
        var currentVc: UIViewController
        var rootCtr = rootVc
        if rootCtr.presentedViewController != nil {
            rootCtr = rootVc.presentedViewController!
        }
        if rootVc.isKind(of: UITabBarController.classForCoder()) {
            currentVc = getCurrentViewController((rootVc as! UITabBarController).selectedViewController!)
        } else if rootVc.isKind(of: UINavigationController.classForCoder()) {
            currentVc = getCurrentViewController((rootVc as! UINavigationController).visibleViewController!)
        } else {
            currentVc = rootCtr
        }
        return currentVc
    }
}
