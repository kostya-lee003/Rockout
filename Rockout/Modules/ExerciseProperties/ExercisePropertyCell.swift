//
//  ExercisePropertyCell.swift
//  Rockout
//
//  Created by Kostya Lee on 18/12/23.
//

import Foundation
import UIKit
import SnapKit

public class ExercisePropertyCell: UITableViewCell {
    private var property: ExerciseProperty = .none

    private let valueTextField = UITextField()
    private let valueLabel = UILabel()
    private let restPickerBg = UIView()
    private let restPickerLabel = UILabel()
    private let touchView = UIButton()
    
    private let picker = TimePicker()

    public var pickRestTime: CompletionHandler = nil
    public var endedEditingClosure: ((String) -> Void)?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        valueTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.right.equalTo(contentView.snp.centerX)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-padding)
            make.left.equalTo(contentView.snp.centerX)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        restPickerBg.snp.makeConstraints { make in
            make.width.equalTo(restPickerLabel.textWidth + padding*2)
            make.height.equalTo(34)
            make.right.equalToSuperview().offset(-padding)
            make.centerY.equalToSuperview()
        }
        restPickerBg.layer.cornerRadius = 8

        restPickerLabel.snp.makeConstraints { make in
            make.size.equalTo(restPickerBg.snp.size)
            make.center.equalTo(restPickerBg.snp.center)
        }
        touchView.frame = contentView.bounds
    }
    
    public func initViews() {
        valueTextField.delegate = self
        
        self.contentView.addSubview(valueTextField)
        
        valueLabel.font = .systemFont(ofSize: 17)
        valueLabel.textColor = .description
        valueLabel.textAlignment = .right
        self.contentView.addSubview(valueLabel)

        restPickerBg.backgroundColor = .background
        self.contentView.addSubview(restPickerBg)

        restPickerLabel.text = "..."
        restPickerLabel.font = .systemFont(ofSize: 17)
        restPickerLabel.textColor = .primaryLabel
        restPickerLabel.textAlignment = .center
        self.contentView.addSubview(restPickerLabel)

        touchView.addTarget(self, action: #selector(touchViewSelected), for: .touchUpInside)
        self.contentView.addSubview(touchView)

        restPickerBg.isHidden = true
        restPickerLabel.isHidden = true
        self.textLabel?.isHidden = true
        self.valueLabel.isHidden = true
    }

    public func set(_ property: ExerciseProperty) {
        self.property = property
        configure()
    }

    private func configure() {
        valueTextField.placeholder = getPropertyText()
        textLabel?.text = getPropertyText()

        if self.property == .restTime {
            restPickerBg.isHidden = false
            restPickerLabel.isHidden = false
            valueLabel.isHidden = true
            valueTextField.isHidden = true
            textLabel?.isHidden = false
        }
    }

    @objc private func touchViewSelected() {
        if self.property == .restTime {
            pickRestTime?()
        } else {
            self.valueTextField.becomeFirstResponder()
        }
    }

    private func getPropertyText() -> String {
        switch property {
        case .sets:
            return "Подходы"
        case .reps:
            return "Повторения"
        case .weight:
            return "Вес"
        case .restTime:
            return "Время отдыха"
        case .note:
            return "Примечание"
        case .none:
            return ""
        }
    }
}

extension ExercisePropertyCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        beganEditing()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        endedEditing(textFieldText: textField.text)
    }
    
    public func beganEditing() {
        valueLabel.isHidden = true
        valueTextField.isHidden = false
        textLabel?.isHidden = true
        touchView.isHidden = true
    }
    
    public func endedEditing(textFieldText: String?) {
        if textFieldText?.trimmingCharacters(in: .whitespaces) != "" {
            valueLabel.isHidden = false
            valueTextField.isHidden = true
            textLabel?.isHidden = false
            touchView.isHidden = false

            valueLabel.text = textFieldText?.trimmingCharacters(in: .whitespaces)
        }
        endedEditingClosure?(textFieldText ?? "")
    }
    
    public func fillRest(_ str: String?) {
        restPickerLabel.text = str
        endedEditingClosure?(str ?? "")
    }
}
