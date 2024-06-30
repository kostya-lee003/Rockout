//
//  DaysListCell.swift
//  Rockout
//
//  Created by Kostya Lee on 04/10/23.
//

import UIKit
import SnapKit

public class DaysListCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let titleBackground = UIButton()
    private let exercisesCountIcon = UIImageView()
    private let exercisesCountLabel = UILabel()

    private let exerciseOneLabel = UILabel()
    private let exerciseTwoLabel = UILabel()
    private let exerciseThreeLabel = UILabel()
    private let exerciseFourLabel = UILabel()
    private let additionalExercisesLabel = UILabel()
    private let emptyImage = UIImageView()
    private let emptyLabel = UILabel()

    private let moreImgView = UIImageView()
    private let moreLabel = UILabel()
    
    private let separator = UIView()
    
    public var selectedTitleClosure: CompletionHandler = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(withModel entity: DayEntity, allExercises: [ExerciseDataEntity]) {
        titleLabel.text = entity.name
        
        let count = entity.exerciseConfigs?.count ?? 0
        exercisesCountLabel.text = "\(count) упражнений"
        
        var resultArr = [ExerciseDataEntity]()
        let array = (entity.exerciseConfigs?.array as? [ExerciseConfigEntity])
        for i in 0...(array?.count ?? 0) {
            if let searchedEntity = allExercises.first(where: { exercise in
                exercise.id == array?[safe: i]?.exerciseInfoId
            }) { // If let block starts
                resultArr.append(searchedEntity)
            }
        }
        exerciseOneLabel.text = resultArr[safe: 0]?.name
        exerciseTwoLabel.text = resultArr[safe: 1]?.name
        exerciseThreeLabel.text = resultArr[safe: 2]?.name
        exerciseFourLabel.text = resultArr[safe: 3]?.name
        if count == 5 {
            moreLabel.text = "еще 1 упражнение"
        } else if count > 5 {
            moreLabel.text = "еще \(count - 4) упражнений"
        } else {
            moreLabel.text = nil
        }
        hideUnnesessaryViews(entities: resultArr)
    }

    private func hideUnnesessaryViews(entities: [ExerciseDataEntity]) {
        exerciseOneLabel.isHidden = !entities.indices.contains(0)
        exerciseTwoLabel.isHidden = !entities.indices.contains(1)
        exerciseThreeLabel.isHidden = !entities.indices.contains(2)
        exerciseFourLabel.isHidden = !entities.indices.contains(3)
        if entities.isEmpty {
            emptyImage.isHidden = false
            emptyLabel.isHidden = false
        } else {
            emptyImage.isHidden = true
            emptyLabel.isHidden = true
        }
        if entities.count > 4 {
            moreLabel.isHidden = false
            moreImgView.isHidden = false
        } else {
            moreLabel.isHidden = true
            moreImgView.isHidden = true
        }
    }
    
    private func initViews() {
        titleBackground.backgroundColor = .bottomSeparatorColor
        contentView.addSubview(titleBackground)
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
//        let gesture = UIGestureRecognizer(target: self, action: #selector(selectedTitle))
//        titleBackground.addGestureRecognizer(gesture)
        titleBackground.addTarget(self, action: #selector(selectedTitle), for: .touchUpInside)
        
        exercisesCountIcon.image = .cardsIcon
        contentView.addSubview(exercisesCountIcon)
        
        exercisesCountLabel.font = .systemFont(ofSize: 17, weight: .regular)
        exercisesCountLabel.textColor = .systemGray3
        contentView.addSubview(exercisesCountLabel)

        exerciseOneLabel.textColor = .subtitleColor
        exerciseOneLabel.font = .systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(exerciseOneLabel)
        
        exerciseTwoLabel.textColor = .subtitleColor
        exerciseTwoLabel.font = .systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(exerciseTwoLabel)
        
        exerciseThreeLabel.textColor = .subtitleColor
        exerciseThreeLabel.font = .systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(exerciseThreeLabel)
        
        exerciseFourLabel.textColor = .subtitleColor
        exerciseFourLabel.font = .systemFont(ofSize: 18, weight: .regular)
        contentView.addSubview(exerciseFourLabel)
        
        [exerciseOneLabel, exerciseTwoLabel, exerciseThreeLabel, exerciseFourLabel].forEach { label in
            addCircle(label: label, text: label.text ?? "")
        }

        emptyImage.image = UIImage(systemName: "rectangle.on.rectangle.slash")
        emptyImage.tintColor = .lightGray
        contentView.addSubview(emptyImage)
        
        emptyLabel.text = "Пусто"
        emptyLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        emptyLabel.textColor = .lightGray
        contentView.addSubview(emptyLabel)

        moreLabel.textColor = .systemGray3
        moreLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(moreLabel)
        
        moreImgView.image = UIImage(named: "arrow_down_rect")
        contentView.addSubview(moreImgView)
        
        separator.backgroundColor = .bottomSeparatorColor
        contentView.addSubview(separator)
    }

    private func addCircle(label: UILabel, text: String, fontSize: CGFloat = 18.0) {
        let circle = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: -14, y: 11), radius: 3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        circle.path = path.cgPath
        circle.fillColor = UIColor.bottomSeparatorColor.cgColor
        label.layer.addSublayer(circle)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        titleBackground.roundCorners(.All, radius: 8.0)
        titleBackground.snp.makeConstraints { make in
            make.left.equalTo(padding)
            make.top.equalTo(padding - 4)
            make.width.equalTo(130)
            make.height.equalTo(42)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(titleBackground.snp.width)
            make.center.equalTo(titleBackground.snp.center)
        }

        exercisesCountLabel.snp.makeConstraints { make in
            make.width.equalTo(exercisesCountLabel.textWidth + 7)
            make.right.equalToSuperview().offset(-padding)
            make.height.equalTo(22)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        exercisesCountIcon.snp.makeConstraints { make in
            make.right.equalTo(exercisesCountLabel.snp.left).offset(-5)
            make.size.equalTo(23)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        exerciseOneLabel.snp.makeConstraints { make in
            make.left.equalTo(padding + 18)
            make.right.equalToSuperview().offset(-padding)
            make.top.equalTo(titleBackground.snp.bottom).offset(padding)
            make.height.equalTo(21)
        }

        exerciseTwoLabel.snp.makeConstraints { make in
            make.left.equalTo(padding + 18)
            make.right.equalToSuperview().offset(-padding)
            make.top.equalTo(exerciseOneLabel.snp.bottom).offset(4)
            make.height.equalTo(21)
        }

        exerciseThreeLabel.snp.makeConstraints { make in
            make.left.equalTo(padding + 18)
            make.right.equalToSuperview().offset(-padding)
            make.top.equalTo(exerciseTwoLabel.snp.bottom).offset(4)
            make.height.equalTo(21)
        }

        exerciseFourLabel.snp.makeConstraints { make in
            make.left.equalTo(padding + 18)
            make.right.equalToSuperview().offset(-padding)
            make.top.equalTo(exerciseThreeLabel.snp.bottom).offset(4)
            make.height.equalTo(21)
        }

        emptyImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.left.equalToSuperview().offset(padding + 8)
            make.top.equalTo(titleBackground.snp.bottom).offset(padding)
        }

        emptyLabel.snp.makeConstraints { make in
            make.height.equalTo(emptyLabel.textHeight + 8)
            make.left.equalTo(emptyImage.snp.right).offset(8)
            make.centerY.equalTo(emptyImage.snp.centerY)
        }

        if !moreLabel.isHidden && !moreImgView.isHidden {
            moreImgView.snp.makeConstraints { make in
                make.size.equalTo(15)
                make.bottom.equalToSuperview().offset(-8)
                make.right.equalTo(exercisesCountLabel.snp.right)
            }
            
            moreLabel.snp.makeConstraints { make in
                make.width.equalTo(moreLabel.textWidth + 7)
                make.height.equalTo(moreLabel.textHeight)
                make.centerY.equalTo(moreImgView.snp.centerY)
                make.right.equalTo(moreImgView.snp.left).offset(-5)
            }
        }

        separator.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.separatorHeight)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    @objc private func selectedTitle() {
        self.selectedTitleClosure?()
    }
}
