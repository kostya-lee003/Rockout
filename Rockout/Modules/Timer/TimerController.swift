//
//  TimerController.swift
//  Rockout
//
//  Created by Kostya Lee on 14/12/23.
//

import Foundation
import UIKit
import SnapKit
import UserNotifications

public enum TimerState {
    case selectTime, running, paused
}

public class TimerController: UIViewController {
    private let glass = UIVisualEffectView()
    private let touchView = UIButton()

    private let picker = TimePicker()
    private var startButton = UIButton()

    private let progressView = KDCircularProgress()
    private let label = UILabel()
    private let closeButton = UIButton()
    private let pauseButton = UIButton()
    private let hideButton = UIButton()

    public var state: TimerState = .selectTime {
        didSet {
            self.stateChanged()
        }
    }
    
    private var didEndCountdown: ((Double) -> Void)? = nil

    private var progress: Double = 0.0 // Varies from 0 to 1
    private var totalTime: Double = 0.0 // in seconds
    private var timerDuration = 0.0
    private var initialTime = 0.0

    private var timer = Timer()

    static let shared = TimerController()

    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    public func initViews() {
        let effect = UIBlurEffect(style: .systemMaterialDark)
        glass.effect = effect
        self.view.addSubview(glass)

        touchView.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        self.view.addSubview(touchView)

        self.view.addSubview(picker)

        startButton.setImage(UIImage(named: "start"), for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.view.addSubview(startButton)

        progressView.startAngle = -90
        progressView.progressThickness = 0.1
        progressView.trackThickness = 0.1
        progressView.clockwise = true
        progressView.gradientRotateSpeed = 2
        progressView.roundedCorners = true
        progressView.glowMode = .noGlow
        progressView.set(colors: .white)
        progressView.trackColor = .gray.withAlphaComponent(0.4)
        self.view.addSubview(progressView)

        label.font = .systemFont(ofSize: 64, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        self.view.addSubview(label)

        closeButton.setImage(UIImage(named: "close_circle"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        self.view.addSubview(pauseButton)
        
        hideButton.setTitle("Скрыть таймер", for: .normal)
        hideButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        hideButton.setTitleColor(.white, for: .normal)
        hideButton.backgroundColor = .gray.withAlphaComponent(0.4)
        hideButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        self.view.addSubview(hideButton)
        
        stateChanged()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        glass.frame = view.bounds
        touchView.frame = view.bounds
        
        picker.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(190.0)
            make.center.equalToSuperview()
        }
        
        let size = 90.0
        startButton.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-size)
        }
        startButton.roundCorners(.All, radius: size/2)
        startButton.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let progressSize = view.frameWidth*0.79
        let padding = (view.frameWidth - progressSize)/2
        
        progressView.snp.makeConstraints { make in
            make.size.equalTo(progressSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
        
        label.snp.makeConstraints { make in
            make.size.equalTo(progressView.snp.size)
            make.center.equalTo(progressView.snp.center)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.equalTo(padding)
            make.size.equalTo(60)
            make.top.equalTo(progressView.snp.bottom).offset(60)
        }
        
        pauseButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-padding)
            make.size.equalTo(60)
            make.top.equalTo(progressView.snp.bottom).offset(60)
        }
        
        hideButton.snp.makeConstraints { make in
            make.width.equalTo(progressSize)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120)
        }
        hideButton.roundCorners(.All, radius: 16)
    }

    private func stateChanged() {
        // Hide or Show subviews and arrange logic accordingly
        switch state {
        case .selectTime:
            picker.isHidden = false
            startButton.isHidden = false
            touchView.isHidden = false
            
            progressView.isHidden = true
            label.isHidden = true
            closeButton.isHidden = true
            pauseButton.isHidden = true
            hideButton.isHidden = true
            
        case .running:
            picker.isHidden = true
            startButton.isHidden = true
            touchView.isHidden = true
            
            progressView.isHidden = false
            label.isHidden = false
            closeButton.isHidden = false
            pauseButton.isHidden = false
            hideButton.isHidden = false
            
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            
            let fromAngle = -360*progress
            let toAngle = -360.0
            let duration = totalTime - totalTime*progress
            progressView.animate(fromAngle: fromAngle, toAngle: toAngle, duration: duration, completion: nil)
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
//                self.label.text = "\(self.totalTime - self.timerDuration)"
                self.changeLabelText()
                self.timerDuration += 0.1
            })

        case .paused:
            picker.isHidden = true
            startButton.isHidden = true
            touchView.isHidden = true
            
            progressView.isHidden = false
            label.isHidden = false
            closeButton.isHidden = false
            pauseButton.isHidden = false
            hideButton.isHidden = false
            
            pauseButton.setImage(UIImage(named: "start"), for: .normal)
            
            progressView.pauseAnimation()
            timer.invalidate()
            
            self.progress = 1 - progressView.progress
        }
    }
    /// Changes timer label text according to Timer() changing value
    private func changeLabelText() {
        let time = self.totalTime - self.timerDuration
        if (time / 60) >= 1 {
            let minutes: Int = Int(time / 60)
            let seconds = Int(time - Double(minutes*60))
            let minutesStr = minutes < 10 ? "0\(Int(minutes))" : "\(Int(minutes))"
            let secondsStr = seconds < 10 ? "0\(Int(seconds))" : "\(Int(seconds))"
            label.text = "\(minutes):\(seconds)"
        } else {
            let timeStr = time < 10 ? "0\(Int(time))" : "\(Int(time))"
            label.text = "00:\(timeStr)"
        }
        if time <= 0 {
            reset()
            self.didEndCountdown?(initialTime)
        }
    }

    private func reset() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            timerDuration = 0
            progress = 0
            state = .selectTime
            timer.invalidate()
            progressView.stopAnimation()
        }
    }
}

// MARK: @objc handling
extension TimerController {

    @objc func dismissVC() {
        hideTimer()
    }

    @objc func startButtonTapped() {
        checkPremission { [weak self] didAllow in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if didAllow {
                    initialTime = picker.getTime()
                    totalTime = Double(picker.minutes*60 + picker.seconds)
                    state = .running
                    changeLabelText()
                    dispatchNotification(timeInterval: picker.getTime())
                }
            }
        }
    }

    @objc func closeButtonTapped() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [rest_notification_id])
        hideTimer { [weak self] in
            self?.reset()
        }
    }

    @objc func pauseButtonTapped() {
        if state == .paused {
            state = .running
            setupAlarmNotification()
        } else if state == .running {
            state = .paused
            cancelAlarmNotification()
        }
    }
    
    @objc func hideButtonTapped() {
        hideTimer()
    }
}

extension TimerController {
    private func checkPremission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    completion(didAllow)
                }
            case .denied:
                self.presentInfoAlert(title: "Включите уведомления", message: "Включите уведомления в настройках приложения чтобы начать таймер")
                completion(false)
            case .authorized:
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    private func cancelAlarmNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [rest_notification_id])
    }
    
    // Called after timer is resumed
    private func setupAlarmNotification() {
        dispatchNotification(timeInterval: totalTime - timerDuration)
    }

    private func dispatchNotification(timeInterval: TimeInterval) {
        let title = "Окончание перерыва"
        let body = "Ваш перерыв в\(picker.minutes == 0 ? "" : " \(picker.minutes) минут") \(picker.seconds)  секунд завершился."

        // Create content for the notification
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
//        content.interruptionLevel = .active

        // Specify the sound to be played
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm.mp3"))

        // Create trigger for the notification (e.g., X seconds from now)
        let timeInterval = picker.getTime()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(
            identifier: rest_notification_id,
            content: content,
            trigger: trigger
        )
        center.removePendingNotificationRequests(withIdentifiers: [rest_notification_id])
        center.add(request)
    }
    
    public func showTimer(didEndCountdown: ((Double) -> Void)?  = nil) {
        self.didEndCountdown = didEndCountdown
        // Adds child to current vc
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.addChild(TimerController.shared)
        TimerController.shared.view.frame = rootVC?.view.frame ?? .zero
        rootVC?.view.addSubview(TimerController.shared.view)
        TimerController.shared.didMove(toParent: rootVC)
        
        // Animate
        TimerController.shared.view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            TimerController.shared.view.alpha = 1.0
        }
    }

    public func hideTimer(completion: CompletionHandler = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            TimerController.shared.view.alpha = 0
        }, completion: { completed in
            if completed {
                TimerController.shared.view.removeFromSuperview()
                let rootVC = UIApplication.shared.keyWindow?.rootViewController
                TimerController.shared.removeFromParent()
                completion?()
            }
        })
    }
}

public func showTimer(didEndCountdown: ((Double) -> Void)? = nil) {
    TimerController.shared.showTimer(didEndCountdown: didEndCountdown)
}

public func hideTimer(completion: CompletionHandler = nil) {
    TimerController.shared.hideTimer(completion: completion)
}
