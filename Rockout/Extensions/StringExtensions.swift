//
//  StringExtensions.swift
//  Rockout
//
//  Created by Kostya Lee on 26/10/23.
//

import UIKit

extension String {
    public func size(_ font: UIFont) -> CGSize {
        let str: NSString = self as NSString
        return str.size(withAttributes: [NSAttributedString.Key.font: font])
    }
    public func width(_ font: UIFont) -> CGFloat {
        return size(font).width
    }
    public func height(_ font: UIFont) -> CGFloat {
        return size(font).height
    }
}

extension String {
    func localizedExercise() -> String {
        NSLocalizedString(self, tableName: "LocalizableExercises", bundle: .main, value: self, comment: self)
    }
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

extension String {
    public func withoutWhitespaces() -> String {
        return self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
    }
}

extension String? {
    public func safe() -> String {
        if self == nil {
            return ""
        }
        return self!
    }
}

extension String {
    /// Returns height of text with arg font and line height
    public func heightWithWidth(width: CGFloat, font: UIFont, lineHeight: CGFloat? = nil) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        var attributes: [NSAttributedString.Key:Any] = [NSAttributedString.Key.font: font]
        if lineHeight != nil {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineHeight!
            attributes[kCTParagraphStyleAttributeName as NSAttributedString.Key] = style
        }
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return boundingBox.height
    }

    /// Returns height of text with arg font
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

extension String {
    public func containsRussianLetters() -> Bool {
        return self.range(of: "[а-яА-Я]", options: .regularExpression) != nil
    }
}
