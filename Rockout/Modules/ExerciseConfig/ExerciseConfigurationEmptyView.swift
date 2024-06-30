//
//  ExerciseConfigurationEmptyView.swift
//  Rockout
//
//  Created by Kostya Lee on 05/03/24.
//

import Foundation
import UIKit
import SnapKit

public class ExerciseConfigurationEmptyView: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var button = UIButton()

    public var action: CompletionHandler = nil

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let offset = 10

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(70.0)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset)
            make.width.equalTo(320.0)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(offset)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
    }

    public func initViews() {
        imageView.image = UIImage(named: "flexed_arm")
        self.addSubview(imageView)

        titleLabel.text = "Добавьте подход"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .primaryLabel
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)

        subtitleLabel.text = "Добавьте свой первый подход чтобы начать отслеживать свои результаты в тренировках"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = .description
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        self.addSubview(subtitleLabel)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Продолжить"
        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = .primaryTint
        configuration.contentInsets = .zero
        button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectedButton), for: .touchUpInside)
        self.addSubview(button)
    }

    public func getHeight() -> CGFloat {
        304.0
    }

    @objc private func selectedButton() {
        self.action?()
    }
}

