//
//  ProgramsListCell.swift
//  Rockout
//
//  Created by Kostya Lee on 01/10/23.
//

import UIKit
import SnapKit

public class ProgramsListCell: UITableViewCell {
    private let _imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let daysLabel = UILabel()
    private let editButton = UIButton()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        _imageView.backgroundColor = .gray
        self.addSubview(_imageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.addSubview(titleLabel)
        titleLabel.isUserInteractionEnabled = false
        
        descriptionLabel.textColor = .description
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.numberOfLines = 2
        self.addSubview(descriptionLabel)
        
        daysLabel.textColor = .description
        daysLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.addSubview(daysLabel)
    }

    public func update(_ model: ProgramEntity) {
        if let data = model.image {
            _imageView.image = UIImage(data: data)
        } else {
            _imageView.image = UIImage(named: "AppIcon")
        }

        titleLabel.text = model.name
        descriptionLabel.text = model.desc == nil || model.desc == "" ? "Нет описания" : model.desc

        let daysCount = (model.days?.array as? [DayEntity])?.count ?? 0
        let daysStr = daysCount == 1 ? "день" : "дней"
        daysLabel.text = "\(daysCount) \(daysStr)"
    }

    public func layout() {
        let imageSize = contentView.frameWidth / 4.5

        _imageView.roundCorners(.All, radius: 15.0)
        _imageView.snp.makeConstraints { make in
            make.left.equalTo(padding)
            make.centerY.equalTo(contentView.snp.centerY)
            make.size.equalTo(imageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(_imageView.snp.right).offset(padding)
            make.top.equalTo(_imageView.snp.top).offset(4)
            make.width.equalTo(250)
            make.height.equalTo(22)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(_imageView.snp.right).offset(padding)
            make.centerY.equalToSuperview()
            make.width.equalTo(250)
//            make.height.equalTo(22)
        }

        daysLabel.snp.makeConstraints { make in
            make.left.equalTo(_imageView.snp.right).offset(padding)
            make.top.equalTo(_imageView.snp.bottom).offset(-22)
            make.width.equalTo(120)
            make.height.equalTo(22)
        }
    }

    public override func layoutSubviews() {
        layout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
//        _imageView.image = nil
    }
}
