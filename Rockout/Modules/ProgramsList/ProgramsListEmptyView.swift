//
//  ProgramsListEmptyView.swift
//  Rockout
//
//  Created by Kostya Lee on 01/02/24.
//

import Foundation
import UIKit
import SnapKit

public class ProgramsListEmptyView: UIView {

    private let imageView = UIImageView()
    private let titleLbl = UILabel()
    private let descriptionLbl = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public func initViews() {
        imageView.image = UIImage(systemName: "dumbbell")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        addSubview(imageView)

        titleLbl.text = "Ваши программы"
        titleLbl.font = .systemFont(ofSize: 20, weight: .bold)
        titleLbl.textColor = .primaryLabel
        titleLbl.textAlignment = .center
        addSubview(titleLbl)

        descriptionLbl.text = "Здесь будут отображаться ваши программы тренировок."
        descriptionLbl.font = .systemFont(ofSize: 15, weight: .light)
        descriptionLbl.textColor = .description
        descriptionLbl.textAlignment = .center
        descriptionLbl.numberOfLines = 0
        addSubview(descriptionLbl)
    }
    
    public func layout() {
        
        let offset = 6
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            make.top.equalTo(imageView.snp.bottom).offset(offset)
        }
        
        descriptionLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(offset)
            make.left.equalToSuperview().offset(padding*2)
            make.right.equalToSuperview().offset(-padding*2)
        }
    }
    
    public static func height() -> CGFloat {
        200
    }
}
