//
//  UILabelExtensions.swift
//  Rockout
//
//  Created by Kostya Lee on 09/05/23.
//

import UIKit

extension UILabel {
    var textWidth: CGFloat {
        return (self.text ?? "").width(self.font)
    }
    
    var textHeight: CGFloat {
        return (self.text ?? "").height(self.font)
    }
    
    func heightForText(withWidth width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
        guard let text = self.text else { return 0 }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingBox = attributedText.boundingRect(with: constraintRect,
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func textHeight(_ width: CGFloat) -> CGFloat {
        return self.text?.heightWithConstrainedWidth(width: width, font: self.font) ?? 0
    }
}
