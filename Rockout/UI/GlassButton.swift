//
//  GlassButton.swift
//  Rockout
//
//  Created by Kostya Lee on 06/12/23.
//

import Foundation
import UIKit
import SnapKit

public class GlassButton: UIView {
    private let glass = UIVisualEffectView()
    private let titleLabel = UILabel()
    private let imgView = UIImageView()
    private let touchView = UIButton()
    
    private var style: UIBlurEffect.Style
    
    public var tapped: CompletionHandler = nil
    
    public var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            layoutSubviews()
        }
    }
    
    convenience init(style: UIBlurEffect.Style, title: String, image: UIImage?) {
        self.init()
        self.style = style
        initViews(title: title, image: image)
    }
    
    override init(frame: CGRect) {
        self.style = .systemThinMaterial
        super.init(frame: frame)
        initViews(title: "", image: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews(title: String, image: UIImage?) {
        let effect = UIBlurEffect(style: self.style)
        glass.effect = effect
        self.addSubview(glass)
        
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 22, weight: .medium)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        if let image {
            imgView.image = image
            self.addSubview(imgView)
        }
        
        self.addSubview(touchView)
        touchView.addTarget(self, action: #selector(touchViewTapped), for: .touchUpInside)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.glass.frame = self.bounds
        self.glass.roundCorners(.All, radius: 12)
        
        let hasImage = imgView.image != nil
        let offset = hasImage ? 30.0 : 0.0
//        titleLabel.snp.makeConstraints { make in
//            make.width.equalTo(titleLabel.textWidth + 10)
//            make.height.equalTo(titleLabel.textHeight)
//            make.centerX.equalToSuperview().offset(offset)
//            make.centerY.equalToSuperview()
//        }
//        
//        if hasImage {
//            imgView.snp.makeConstraints { make in
//                make.width.equalTo(32)
//                make.height.equalTo(32)
//                make.right.equalTo(titleLabel.snp.left).offset(-20)
//                make.centerY.equalToSuperview()
//            }
//        }
        var x = CGFloat(0)
        var y = CGFloat(0)
        var w = CGFloat(0)
        var h = CGFloat(0)
        
        w = titleLabel.textWidth + 10
        h = titleLabel.textHeight
        x = glass.centerX - w/2 + offset
        y = glass.centerY - h/2
        titleLabel.frame = CGRect(x: x, y: y, width: w, height: h)

        if hasImage {
            w = 32
            h = 32
            x = titleLabel.frame.minX - w - 10
            y = glass.centerY - h/2
            imgView.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        touchView.frame = self.bounds
    }
    
    @objc func touchViewTapped() {
        self.tapped?()
    }
}

extension GlassButton {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Darken button
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // return button to origin
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // return button to origin
    }
}
