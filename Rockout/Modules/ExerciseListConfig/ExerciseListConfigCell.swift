//
//  ExerciseListConfigCell.swift
//  Rockout
//
//  Created by Kostya Lee on 17/01/24.
//

import Foundation
import UIKit
import SnapKit

public class ExerciseListConfigCell: UITableViewCell {

    private let editButton = UIButton()
    private let touchView = UIButton()
    
    public var selectedClosure: CompletionHandler = nil
    public var editClosure: CompletionHandler = nil
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .primaryLabel
        self.contentView.addSubview(titleLabel)
        
        subtitleLabel.font = .systemFont(ofSize: 17)
        subtitleLabel.textColor = .secondaryLabel
        self.contentView.addSubview(subtitleLabel)

        self.textLabel?.textAlignment = .left
        self.detailTextLabel?.backgroundColor = .red

        editButton.setImage(
            UIImage(named: "edit")?.withTintColor(
                .lightGray,
                renderingMode: .alwaysOriginal
            ),
            for: .normal
        )
        editButton.addTarget(self, action: #selector(editButtonSelected), for: .touchUpInside)
        self.contentView.addSubview(editButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        editButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-padding)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY)
            make.left.equalTo(padding)
            make.width.equalToSuperview().offset(-padding*2-30)
        }
        
        self.subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(padding)
            make.width.equalToSuperview().offset(-padding*2-30)
        }
    }
    
    public func hideEditButton() {
        self.editButton.isHidden = true
    }

    @objc private func editButtonSelected() {
        editClosure?()
    }
}

extension UIButton {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
