//
//  DatePickerController.swift
//  Rockout
//
//  Created by Kostya Lee on 17/05/24.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Present as modal!
public class DatePickerController: UIViewController {

    private let background = UIView()
    private let titleLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let button = GlassButton(style: .systemUltraThinMaterialDark, title: "Начать тренировку", image: nil)
    
    private var date: Date = Date()
    
    public var willDismissWithDate: (Date) -> Void = {_ in}

    public override func viewDidLoad() {
        super.viewDidLoad()
        background.backgroundColor = .white
        view.addSubview(background)
        
        titleLabel.text = "Сегодня"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .primaryLabel
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        view.addSubview(datePicker)
        
        button.tapped = { [weak self] in
            guard let self else { return }
            willDismissWithDate(date)
            self.dismiss(animated: true)
        }
        view.addSubview(button)
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let selectedDate = dateFormatter.string(from: sender.date)
        print("Selected date: \(selectedDate)")
        self.date = sender.date
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Layout will be structured from bottom to top (starting from GlassButton)
        button.snp.makeConstraints { make in
            make.width.equalTo(view.frameWidth - padding*2)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-padding*2)
        }

        datePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(360)
            make.bottom.equalTo(button.snp.top).offset(-padding)
        }
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(datePicker.snp.top).offset(-padding)
        }
        
        background.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.top).offset(-padding)
        }
        background.layer.cornerRadius = 15
        background.layer.masksToBounds = true
    }
}
