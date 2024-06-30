//
//  CreateProgramController.swift
//  Rockout
//
//  Created by Kostya Lee on 20/12/23.
//

import Foundation
import UIKit
import SnapKit
import IQKeyboardManagerSwift

// MARK: Create or edit program
public class CreateProgramController: UIViewController {
    
    private let bg = UIView()
    private let touchView = UIButton()

    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let imageLabel = UILabel()
    
    private let nameTextFieldBg = UIView()
    private let nameTextField = UITextField()
    private let textFieldSeparator = UIView()
    private let descTextFieldBg = UIView()
    private let descTextField = UITextField()

    private var continueButton = UIButton()

    private var keyboardHeight: CGFloat = 400.0
    
    private weak var pickedImage: UIImage?
    public var dismissed: ((ProgramEntity) -> Void)?
    
    private var model: ProgramEntity?
    
    init(model: ProgramEntity? = nil) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(touchView)
        
        bg.backgroundColor = .secondaryBackground
        self.view.addSubview(bg)
        
        titleLabel.text = model == nil ? "Новая программа" : "Изменить программу"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .primaryLabel
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        imageView.image = UIImage(named: "plus_rect2")
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        if let data = model?.image {
            imageView.image = UIImage(data: data)
        }
        
        imageLabel.text = model == nil ? "Выбрать фотографию" : "Изменить фотографию"
        imageLabel.font = .systemFont(ofSize: 16)
        imageLabel.textColor = .description
        imageLabel.textAlignment = .center
        imageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
        imageLabel.isUserInteractionEnabled = true
        self.view.addSubview(imageLabel)
        
        nameTextFieldBg.backgroundColor = .white
        self.view.addSubview(nameTextFieldBg)
        
        nameTextField.textAlignment = .center
        nameTextField.placeholder = "Введите название"
        self.view.addSubview(nameTextField)
        nameTextField.text = model?.name
        
        descTextFieldBg.backgroundColor = .white
        self.view.addSubview(descTextFieldBg)
        
        descTextField.textAlignment = .center
        descTextField.placeholder = "Введите описание"
        self.view.addSubview(descTextField)
        descTextField.text = model?.desc
        
        textFieldSeparator.backgroundColor = .textFieldBorder
        self.view.addSubview(textFieldSeparator)

        var configuration = UIButton.Configuration.filled()
        configuration.title = model == nil ? "Создать" : "Изменить"
        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = .primaryTint
        configuration.contentInsets = .zero
        continueButton = UIButton(configuration: configuration)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        self.view.addSubview(continueButton)
        
        touchView.addTarget(self, action: #selector(touchViewSelected), for: .touchUpInside)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    /// !!! Layout from bottom to top, not vice verca as usual !!!
    public func layout() {
        let offset = 10.0
        
        touchView.frame = self.view.bounds
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-padding*2)
            make.width.equalTo(230)
            make.centerX.equalToSuperview()
            make.height.equalTo(42)
        }

        descTextFieldBg.snp.makeConstraints { make in
            make.width.equalTo(continueButton.snp.width)
            make.height.equalTo(continueButton.snp.height)
            make.bottom.equalTo(continueButton.snp.top).offset(-padding)
            make.centerX.equalToSuperview()
        }
        descTextFieldBg.roundCorners(.Bottom, radius: 12)

        descTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(descTextFieldBg.snp.height)
            make.center.equalTo(descTextFieldBg.snp.center)
        }

        textFieldSeparator.snp.makeConstraints { make in
            make.width.equalTo(nameTextFieldBg)
            make.height.equalTo(0.5)
            make.top.equalTo(descTextFieldBg.snp.top)
            make.centerX.equalToSuperview()
        }

        nameTextFieldBg.snp.makeConstraints { make in
            make.width.equalTo(continueButton.snp.width)
            make.height.equalTo(continueButton.snp.height)
            make.bottom.equalTo(textFieldSeparator.snp.top)
            make.centerX.equalToSuperview()
        }
        nameTextFieldBg.roundCorners(.Top, radius: 12)

        nameTextField.snp.makeConstraints { make in
            make.width.equalTo(descTextField.snp.width)
            make.height.equalTo(nameTextFieldBg.snp.height)
            make.center.equalTo(nameTextFieldBg.snp.center)
        }

        imageLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-offset*2)
            make.height.equalTo(41)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nameTextFieldBg.snp.top).offset(-offset*2)
        }

        imageView.snp.makeConstraints { make in
            make.size.equalTo(65)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageLabel.snp.top).offset(-offset)
        }
        imageView.roundCorners(.All, radius: 15)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-offset*2)
            make.height.equalTo(41)
            make.bottom.equalTo(imageView.snp.top).offset(-offset*2)
        }
        
        bg.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.top).offset(-offset*2)
        }
        bg.roundCorners(.Top, radius: 13)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        IQKeyboardManager.shared.enable = true
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
        IQKeyboardManager.shared.enable = false
    }
    
    public func present(on vc: UIViewController) {
        vc.present(self, animated: true)
    }
    
    public func proceed(model: ProgramEntity) {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.dismissed?(model)
        }
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateImageView() {
        self.imageView.image = pickedImage
    }
}

// MARK: @objc
private extension CreateProgramController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.keyboardHeight = keyboardFrame.cgRectValue.height
                self.layout()
            }
        }
    }

    @objc func touchViewSelected() {
        if nameTextField.isFirstResponder {
            view.endEditing(true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func selectImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        // Present loading
        present(picker, animated: true) {
            // Dismiss loading
        }
    }

    @objc private func continueButtonTapped() {
        do {
            /// If model is nil, then create program, else edit program
            if let model {
                model.name = nameTextField.text
                model.desc = descTextField.text
                model.image = self.pickedImage?.jpegData(compressionQuality: 1.0)
                try CoreDataManager.shared.context.save()
                self.proceed(model: model)
            } else {
                let new = ProgramEntity(context: CoreDataManager.shared.context)
                new.id = UUID()
                new.name = nameTextField.text
                new.desc = descTextField.text
                new.createdAt = Date()
                new.image = self.pickedImage?.jpegData(compressionQuality: 1.0)
                try CoreDataManager.shared.context.save()
                self.proceed(model: new)
            }
        } catch {
            NSLog(commonLogFormat, "Could not save context")
        }
    }
}

extension CreateProgramController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let img = info[.editedImage] as? UIImage {
            self.pickedImage = img
            self.updateImageView()
        }
        picker.dismiss(animated: true)
    }
}
