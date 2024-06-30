//
//  ExerciseListCell.swift
//  Rockout
//
//  Created by Kostya Lee on 18/12/23.
//

import Foundation
import UIKit
import SnapKit

public class ExerciseListCell: UITableViewCell {
    
    public var cellIsSelected: Bool = false
    
    private let editButton = UIButton()
    private let touchView = UIButton()
    
    public var selectedClosure: CompletionHandler = nil
    public var editClosure: CompletionHandler = nil
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        touchView.addTarget(self, action: #selector(touchViewSelected), for: .touchUpInside)
        self.contentView.addSubview(touchView)

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
        
        touchView.frame = contentView.bounds
    }
    
    public func hideEditButton() {
        self.editButton.isHidden = true
    }

    @objc private func touchViewSelected() {
        self.selectedClosure?()
        self.cellIsSelected.toggle()
    }
    
    @objc private func editButtonSelected() {
        editClosure?()
    }
}
