//
//  ExerciseSelectionCell.swift
//  Rockout
//
//  Created by Kostya Lee on 24/05/24.
//

import Foundation
import UIKit
import SnapKit

public class ExerciseSelectionCell: UITableViewCell {
    
    public var cellIsSelected: Bool = false
    
    private let infoButton = UIButton()
    private let checkmarkImageView = UIImageView()
    
    private let touchView = UIButton()
    
    public var selectedClosure: CompletionHandler = nil
    public var showInfo: CompletionHandler = nil
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        checkmarkImageView.image = UIImage(named: "checkmark")
        self.contentView.addSubview(checkmarkImageView)
        self.checkmarkImageView.isHidden = true
        
        touchView.addTarget(self, action: #selector(touchViewSelected), for: .touchUpInside)
        self.contentView.addSubview(touchView)
        
        infoButton.setImage(
            UIImage(systemName: "info.circle")?.withTintColor(
                .lightGray,
                renderingMode: .alwaysOriginal
            ),
            for: .normal
        )
        infoButton.addTarget(self, action: #selector(infoButtonSelected), for: .touchUpInside)
        self.contentView.addSubview(infoButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        infoButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-padding)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-padding)
        }
        
        touchView.frame = contentView.bounds
        
        textLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding-20-10)
            make.centerY.equalToSuperview()
        })
    }

    private func changeUI() {
        if cellIsSelected {
            checkmarkImageView.isHidden = false
            infoButton.isHidden = true
        } else {
            checkmarkImageView.isHidden = true
            infoButton.isHidden = false
        }
    }
    
    @objc private func touchViewSelected() {
        self.selectedClosure?()
        self.cellIsSelected.toggle()
        changeUI()
    }
    
    @objc private func infoButtonSelected() {
        showInfo?()
    }
}
