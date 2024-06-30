//
//  ExerciseGoalsBoardView.swift
//  Rockout
//
//  Created by Kostya Lee on 27/03/24.
//

import Foundation
import UIKit

public class ExerciseGoalsBoardView: UIView {
    
    private let setsBg = UIView()
    private let repsBg = UIView()
    private let weightBg = UIView()
    private let restBg = UIView()

    private let setsLabel = UILabel()
    private let repsLabel = UILabel()
    private let weightLabel = UILabel()
    private let restLabel = UILabel()

    private let setsCountLabel = UILabel()
    private let repsCountLabel = UILabel()
    private let weightCountLabel = UILabel()
    private let restCountLabel = UILabel()

//    private let setsProgress = KDCircularProgress()
//    private let weightProgress = KDCircularProgress()
//    private let repsProgress = KDCircularProgress()
//    private let restProgress = KDCircularProgress()
    
    private let timerButton = UIButton()
    private let timerButtonBg = UIButton()

    private let percentageButton = UIButton()
    private let percentageButtonBg = UIButton()
    
    /// ExerciseGoalsBoardView is actually replacing the first table header view in UITableView in ExerciseConfigurationController. We need to add this label too so user can see the required date for row.
    private let dateLabel = UILabel()

    private let touchView = UIButton()

    private let progressViewAnimationDuration = 0.5
    public let startAngle = 0.0

    public var tappedClosure: CompletionHandler = nil
    public var timerButtonTappedAction: CompletionHandler = nil
    public var percentageButtonTappedAction: CompletionHandler = nil

    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public func initViews() {
        setsBg.backgroundColor = .white
        addSubview(setsBg)
        
        repsBg.backgroundColor = .white
        addSubview(repsBg)
        
        weightBg.backgroundColor = .white
        addSubview(weightBg)
        
        restBg.backgroundColor = .white
        addSubview(restBg)
        
        [weightLabel, setsLabel, repsLabel, restLabel].forEach { label in
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            label.textColor = UIColor(hex: "#75808C")
//            label.adjustsFontSizeToFitWidth = true
            addSubview(label)
        }
        weightLabel.text = "Вес"
        setsLabel.text = "Подходы"
        repsLabel.text = "Повторения"
        restLabel.text = "Время отдыха"
        
        [weightCountLabel, setsCountLabel, repsCountLabel, restCountLabel].forEach { label in
            label.textColor = UIColor(hex: "#323232")
//            label.adjustsFontSizeToFitWidth = true
            label.font = .systemFont(ofSize: 24, weight: .bold)
//            label.text = "0"
            addSubview(label)
        }
        
        // UIColor(hex: "#ECECF1")
        timerButtonBg.backgroundColor = .white
        timerButtonBg.addTarget(self, action: #selector(timerButtonTapped), for: .touchUpInside)
        addSubview(timerButtonBg)
        
        percentageButtonBg.backgroundColor = .white
        percentageButtonBg.addTarget(self, action: #selector(percentageButtonTapped), for: .touchUpInside)
        addSubview(percentageButtonBg)
        
        timerButton.setImage(UIImage(named: "timer"), for: .normal)
        timerButton.addTarget(self, action: #selector(timerButtonTapped), for: .touchUpInside)
        addSubview(timerButton)
        
        percentageButton.setImage(UIImage(named: "percentage"), for: .normal)
        percentageButton.addTarget(self, action: #selector(percentageButtonTapped), for: .touchUpInside)
        addSubview(percentageButton)
        
        dateLabel.textColor = UIColor(hex: "#878787")
        dateLabel.font = .systemFont(ofSize: 15)
        addSubview(dateLabel)

        touchView.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        addSubview(touchView)
    }

    public func layout() {
        
        let screenWidth = UIScreen.main.bounds.size.width
        let cornerRad = 11.0
        let buttonWidth = 45.0
        let widthWithoutPaddings = screenWidth - padding*2 - 11*2
        let singleBGWidth = (widthWithoutPaddings - buttonWidth)/2
        let singleBGHeight = 66.0
        let smallPadding = 11.0

        setsBg.snp.makeConstraints { make in
            make.width.equalTo(singleBGWidth)
            make.height.equalTo(singleBGHeight)
            make.left.equalTo(padding)
            make.top.equalTo(0)
        }

        repsBg.snp.makeConstraints { make in
            make.width.equalTo(singleBGWidth)
            make.height.equalTo(singleBGHeight)
            make.left.equalTo(setsBg.snp.right).offset(smallPadding)
            make.top.equalTo(0)
        }

        weightBg.snp.makeConstraints { make in
            make.width.equalTo(singleBGWidth)
            make.height.equalTo(singleBGHeight)
            make.left.equalTo(padding)
            make.top.equalTo(setsBg.snp.bottom).offset(smallPadding)
        }
        
        restBg.snp.makeConstraints { make in
            make.width.equalTo(singleBGWidth)
            make.height.equalTo(singleBGHeight)
            make.left.equalTo(weightBg.snp.right).offset(smallPadding)
            make.top.equalTo(weightBg.snp.top)
        }

        [setsBg, repsBg, weightBg, restBg].forEach { bg in
//            bg.roundCorners(.All, radius: cornerRad) <- Produces bug
            bg.layer.cornerRadius = cornerRad
            bg.clipsToBounds = true
        }

        var x = 0.0
        var y = 0.0
        var w = 0.0
        var h = 0.0
        
        h = (setsCountLabel.text?.height(setsCountLabel.font) ?? 0) + 5
        x = setsBg.minX + smallPadding
        w = singleBGWidth - smallPadding
        y = 5
        setsCountLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = repsBg.minX + smallPadding
        repsCountLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = weightBg.minY + 5
        x = weightBg.minX + smallPadding
        weightCountLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        x = restBg.minX + smallPadding
        restCountLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = setsCountLabel.maxY
        h = (setsLabel.text?.height(setsLabel.font) ?? 0) + 3
        x = setsBg.minX + smallPadding
        setsLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = repsCountLabel.maxY
        x = repsBg.minX + smallPadding
        repsLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = weightCountLabel.maxY
        x = weightBg.minX + smallPadding
        weightLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        y = restCountLabel.maxY
        x = restBg.minX + smallPadding
        restLabel.frame = CGRect(x: x, y: y, width: w, height: h)

        timerButtonBg.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-padding)
            make.top.equalToSuperview()
            make.width.equalTo(buttonWidth)
            make.height.equalTo(singleBGHeight)
        }
        timerButtonBg.layer.cornerRadius = cornerRad
        timerButtonBg.clipsToBounds = true
        
        percentageButtonBg.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-padding)
            make.top.equalTo(timerButtonBg.snp.bottom).offset(smallPadding)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(singleBGHeight)
        }
        percentageButtonBg.layer.cornerRadius = cornerRad
        percentageButtonBg.clipsToBounds = true
        
        timerButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.center.equalTo(timerButtonBg.snp.center)
        }
        
        percentageButton.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.center.equalTo(percentageButtonBg.snp.center)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.height.equalTo(dateLabel.textHeight + 3)
            make.top.equalTo(weightBg.snp.bottom).offset(padding)
        }

        touchView.snp.makeConstraints { make in
            make.left.equalTo(setsBg.snp.left)
            make.top.equalTo(setsBg.snp.top)
            make.bottom.equalTo(weightBg.snp.bottom)
            make.right.equalTo(repsBg.snp.right)
        }
    }

    public func updateModel(_ model: ExerciseConfigEntity, date: String?) {
        let goal = model.exerciseGoal
        weightCountLabel.text = (goal?.weight ?? "").withoutWhitespaces() == "" ? "0" : goal?.weight
        setsCountLabel.text = (goal?.sets ?? "").withoutWhitespaces() == "" ? "0" : goal?.sets
        repsCountLabel.text = (goal?.reps ?? "").withoutWhitespaces() == "" ? "0" : goal?.reps
        restCountLabel.text = SharedDataManager.getConvertedRestTime(goal?.restTime)

        if let date {
            dateLabel.text = date.uppercased()
        }
        layoutSubviews()
    }

    // on touch view
    @objc private func tapped() {
        self.tappedClosure?()
    }
    
    @objc private func timerButtonTapped() {
        self.timerButtonTappedAction?()
    }
    
    @objc private func percentageButtonTapped() {
        self.percentageButtonTappedAction?()
    }
    
    public func getHeight() -> CGFloat {
        return 172.0
    }
}
