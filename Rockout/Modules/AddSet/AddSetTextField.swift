//
//  AddSetTextField.swift
//  Rockout
//
//  Created by Kostya Lee on 06/03/24.
//

import Foundation
import CoreData
import SnapKit
public class AddSetTextField: UIView, UITextFieldDelegate {
    private let bg = UIView()
    private let mainLabel = UILabel()
    private let secondaryLabel = UILabel()
    private let textField = UITextField()

    private var title: String = ""
    private var subtitle: String = ""

    public var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    public var type: UIKeyboardType {
        get {
            textField.keyboardType
        }
        set {
            textField.keyboardType = newValue
        }
    }
    
    public var textDidChange: ((String?) -> Void)?
    public var endedEditing: ((String?) -> Void)?
    public var shouldReturn: ((String?) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        bg.backgroundColor = .secondaryBackground
        self.addSubview(bg)
        
        mainLabel.font = .systemFont(ofSize: 16)
        mainLabel.textColor = .primaryLabel
        self.addSubview(mainLabel)

        textField.delegate = self
        self.addSubview(textField)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        bg.frame = self.bounds
        bg.roundCorners(.All, radius: 8)

        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.left.equalTo(mainLabel.snp.right).offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.centerY.equalToSuperview()
            make.height.equalTo(30.0)
        }
    }

    public func updateLabels(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.mainLabel.text = title
        textField.placeholder = subtitle
    }

    public func showKeyboard() {
        textField.becomeFirstResponder()
    }
    
    public func hideKeyboard() {
        textField.resignFirstResponder()
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        textDidChange?(textField.text)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        endedEditing?(textField.text)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn?(textField.text)
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Detect backspace key
        if string.isEmpty && range.length > 0 && !(textField.text ?? "").isEmpty {
            // Delete entire textfield text if editing just started
            textField.text = ""
        }
        return true
    }

    public func addToolbar() {
        textField.addDoneCancelToolbar(
            onDone: (target: self, action: #selector(onDone)),
            onCancel: (target: self, action: #selector(onCancel))
        )
    }

    @objc func onDone() {
        textField.resignFirstResponder()
        shouldReturn?(textField.text)
    }

    @objc func onCancel() {
        textField.resignFirstResponder()
    }
}
