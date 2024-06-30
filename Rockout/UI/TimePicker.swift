//
//  TimePicker.swift
//  Rockout
//
//  Created by Kostya Lee on 20/12/23.
//

import Foundation
import UIKit
import SnapKit

// Custom UIPickerView
public class TimePicker: UIView {

    private let minutesItems = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    private let secondsItems = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    
    var minutes: Int = 0
    var seconds: Int = 5
    
    let picker = UIPickerView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.delegate = self
        self.addSubview(picker)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        picker.frame = self.bounds
    }
    
    public func getTimeString() -> String {
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
    
    /// Returns number of picked seconds (with minutes multiplied by 60)
    public func getTime() -> TimeInterval {
        let mSeconds = minutes*60
        return Double(mSeconds + seconds)
    }
}

extension TimePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return minutesItems.count
        case 1:
            return secondsItems.count
        default:
            return 0
        }
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/4
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(minutesItems[row])"
        case 1:
            return "\(secondsItems[row])"
        default:
            return ""
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            minutes = minutesItems[row]
        case 1:
            seconds = secondsItems[row]
        default:
            break;
        }
    }
}
