//
//  PickTimeController.swift
//  Rockout
//
//  Created by Kostya Lee on 20/12/23.
//

import Foundation
import UIKit
import SnapKit

public class PickTimeController: UIViewController {
    private let glass = UIVisualEffectView()
    private let touchView = UIButton()

    private let picker = TimePicker()
    private let button = UIButton()
    
    public var pickedTime: ((Int) -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    public func initViews() {
        let effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        glass.effect = effect
        self.view.addSubview(glass)

        touchView.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        self.view.addSubview(touchView)

        self.view.addSubview(picker)

        button.setTitle("ОК", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.4)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(button)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        glass.frame = self.view.bounds
        touchView.frame = self.view.bounds
        
        picker.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(190.0)
            make.center.equalToSuperview()
        }
        
        let progressSize = self.view.frameWidth*0.79
        button.snp.makeConstraints { make in
            make.width.equalTo(progressSize)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120)
        }
        button.roundCorners(.All, radius: 16)
    }
    
    public func show() {
        // Adds child to current vc
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.addChild(self)
        self.view.frame = rootVC?.view.frame ?? .zero
        rootVC?.view.addSubview(self.view)
        self.didMove(toParent: rootVC)
        
        // Animate
        self.view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }, completion: { completed in
            if completed {
                self.view.removeFromSuperview()
                let rootVC = UIApplication.shared.keyWindow?.rootViewController
                self.removeFromParent()
            }
        })
    }
}

// MARK: @objc handling
extension PickTimeController {
    @objc private func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
    }
    
    @objc func dismissVC() {
        hide()
    }
    
    @objc func buttonTapped() {
        let totalNumOfSeconds = picker.minutes*60 + picker.seconds
        pickedTime?(totalNumOfSeconds)
        hide()
    }
}
