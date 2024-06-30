//
//  ExerciseConfigurationCell.swift
//  Rockout
//
//  Created by Kostya Lee on 19/10/23.
//

import UIKit
import SnapKit

public class ExerciseConfigurationCell: UITableViewCell {
    private let separator = UIView()
    private let titleBg = UIButton()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let subtitleLabel = UILabel()
    static let id = "ExerciseConfigurationCell"
    
    private let formatter = DateFormatter()
    
    public var tappedOnTitle: CompletionHandler = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExerciseConfigurationCell {

    private func initViews() {
        
        self.contentView.backgroundColor = .white
        
        titleBg.backgroundColor = .secondaryBackground
        titleBg.addTarget(self, action: #selector(selectedTitle), for: .touchUpInside)
        self.addSubview(titleBg)
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .primaryLabel
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
//        titleLabel.addGestureRecognizer(tapGesture)
        self.addSubview(titleLabel)
        
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .cellSeparatorColor2
        self.addSubview(timeLabel)
        
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .primaryLabel
        self.addSubview(subtitleLabel)
        
        separator.backgroundColor = .cellSeparatorColor2
        self.addSubview(separator)
        
        formatter.dateFormat = dateFormatForCell
    }
    
    public override func layoutSubviews() {
        let margin = padding

        titleBg.snp.makeConstraints { make in
            make.width.equalTo(120.0)
            make.height.equalTo(45.0)
            make.left.equalTo(margin)
            make.centerY.equalToSuperview()
        }
        titleBg.roundCorners(.All, radius: 10)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(titleBg.snp.center)
            make.size.equalTo(titleBg.snp.size)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.width.equalTo(70.0)
            make.height.equalTo(20.0)
            make.left.equalTo(titleBg.snp.right).offset(10)
            make.top.equalTo(titleBg.snp.top)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.width.equalTo(200.0)
            make.height.equalTo(20.0)
            make.left.equalTo(titleBg.snp.right).offset(10)
            make.top.equalTo(timeLabel.snp.bottom).offset(3)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.separatorHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    public func updateModel(model: SetEntity) {
        /// if weight is '150.0' then it is converted to '150', but if it is '150.5' it stays same.
        let weightString = model.weight.hasFractionalPart() ? model.weight : trunc(model.weight)
        titleLabel.text = "\(weightString)x\(model.reps)"
        if let date = model.date {
            timeLabel.text = formatter.string(from: date)
        }
        let subtitleText = model.note == "" || model.note == nil ? "Нет примечания" : model.note
        subtitleLabel.text = subtitleText
    }
    
    @objc private func selectedTitle() {
        self.tappedOnTitle?()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        timeLabel.text = nil
    }
}
