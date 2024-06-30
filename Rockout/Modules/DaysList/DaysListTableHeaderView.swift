//
//  DaysListHeaderView.swift
//  Rockout
//
//  Created by Kostya Lee on 04/10/23.
//

import UIKit
import SnapKit

public final class DaysListTableHeaderView : UIView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel = UILabel()
    private let editButton = UIButton()

    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    private var bottomGradient = UIView()
    
    public var buttonTappedClosure: CompletionHandler = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        addSubview(containerView)
        
        addGradientLayers()
        containerView.addSubview(imageView)
        
        titleLabel.text = ""
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        containerView.addSubview(titleLabel)
        
        editButton.setImage(.whiteEditIcon, for: .normal)
        editButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        containerView.addSubview(editButton)
        
        setConstraints()
    }
    
    private func layout() {
        let margin = padding

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(31)
            make.width.equalTo(frameWidth - 30)
            make.left.equalTo(margin)
            make.bottom.equalToSuperview().offset(-margin - 6)
        }

        editButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.right.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview().offset(-margin - 6)
        }

        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    @objc private func buttonTapped() {
        self.buttonTappedClosure?()
    }

    public func update(_ model: ProgramEntity) {
        if let data = model.image {
            self.imageView.image = UIImage(data: data)
        }
        self.titleLabel.text = model.name
    }
    
    private func addGradientLayers() {
        let white = UIColor.white
        let black = UIColor.black
        // Create gradient layer
        let topGradientLayer = CAGradientLayer()
        topGradientLayer.frame = bounds
        topGradientLayer.colors = [black.cgColor, white.cgColor]
        topGradientLayer.locations = [0.0, 0.5] // Adjust this to control the gradient's direction and spread
        
        // Add the gradient layer to the view's layer
        containerView.layer.insertSublayer(topGradientLayer, at: 0)
        
        let bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.frame = bounds
        bottomGradientLayer.colors = [black.cgColor, white.cgColor]
        bottomGradientLayer.locations = [1.0, 0.8] // Adjust this to control the gradient's direction and spread
        
        // Add the gradient layer to the view's layer
        containerView.layer.insertSublayer(bottomGradientLayer, at: 0)
        
//        let topView = UIView()
//        topView.backgroundColor = .blue
//        addSubview(topView)
//        topView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalTo(self.snp.top).offset(80)
//        }
//        
//        let bottomView = UIView()
//        bottomView.backgroundColor = .blue
//        addSubview(bottomView)
//        bottomView.snp.makeConstraints { make in
//            make.top.equalTo(self.snp.bottom).offset(-80)
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
    }
}

extension DaysListTableHeaderView {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y) + scrollView.contentInset.top
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
