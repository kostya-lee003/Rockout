//
//  UISelectableLabel.swift
//  Rockout
//
//  Created by Kostya Lee on 29/05/24.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

final class UISelectableLabel: UILabel {
    
  // 1...
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextSelection()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextSelection()
    }
    
    private func setupTextSelection() {
        layer.addSublayer(selectionOverlay)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(didHideMenu), name: UIMenuController.didHideMenuNotification, object: nil)
    }
    
    private let selectionOverlay: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 8
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.14).cgColor
        layer.isHidden = true
        return layer
    }()
  
  // 2...
    
    @objc private func didHideMenu(_ notification: Notification) {
        selectionOverlay.isHidden = true
    }
  
  // 3...
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let text = text, !text.isEmpty else { return }
        becomeFirstResponder()
        
        let menu = menuForSelection()
        if !menu.isMenuVisible {
            selectionOverlay.isHidden = false
//            menu.setTargetRect(textRect(), in: self)
//            menu.setMenuVisible(true, animated: true)
            menu.showMenu(from: self, rect: textRect())
        }
    }
    
    private func textRect() -> CGRect {
        let inset: CGFloat = -4
        return textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines).insetBy(dx: inset, dy: inset)
    }
    
    private func menuForSelection() -> UIMenuController {
        let menu = UIMenuController.shared
        menu.menuItems = [
            UIMenuItem(title: "Copy", action: #selector(copyText)),
            UIMenuItem(title: "Speak", action: #selector(speakText))
        ]
        return menu
    }
  
  // 4...
    
    @objc private func copyText(_ sender: Any?) {
//        cancelSelection()
        let board = UIPasteboard.general
        board.string = text
    }
    
    @objc private func speakText(_ sender: Any?) {
//        cancelSelection()
        guard let text = text, !text.isEmpty else { return }
        
        if #available(iOS 10.0, *) {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
        }
      
      // 5...
      
        let speechSynthesizer = AVSpeechSynthesizer.forSpeakSelection
        if speechSynthesizer.isSpeaking { speechSynthesizer.stopSpeaking(at: .word) }
        
        let utterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(utterance)
    }
}


extension AVSpeechSynthesizer {
    
    static let forSpeakSelection: AVSpeechSynthesizer = {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = SpeechDelegate.shared
        return synthesizer
    }()
}

// MARK: - Private

/// Delegate is used to deactivate the audio session when a synthesized utterance has finished.
private class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    
    static let shared = SpeechDelegate()
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
