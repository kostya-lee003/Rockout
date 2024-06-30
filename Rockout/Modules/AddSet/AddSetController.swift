//
//  AddSetController.swift
//  Rockout
//
//  Created by Kostya Lee on 13/12/23.
//

import Foundation
import UIKit
import SnapKit
import CoreData

public class AddSetController: UIViewController {

    private let bg = UIView()
    private let touchView = UIButton()
    
    private let weightTF = AddSetTextField()
    private let repsTF = AddSetTextField()
    private let noteTF = AddSetTextField()

    private let addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        if let image = UIImage(systemName: "plus") {
            configuration.image = image
                .applyingSymbolConfiguration(.init(pointSize: 20))
        }
        configuration.title = "Добавить подход"
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .primaryTint
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var keyboardHeight: CGFloat = 400.0

    public var dismissedWithBlock: ((SetEntity) -> Void)?

    private var model: ExerciseConfigEntity
    private var lastSet: SetEntity?

    init(model: ExerciseConfigEntity) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(touchView)
        
        bg.backgroundColor = .white
        view.addSubview(bg)

        weightTF.updateLabels(title: "Вес", subtitle: model.exerciseGoal?.weight ?? "Пусто")
        weightTF.type = .numberPad
        weightTF.addToolbar()
        weightTF.shouldReturn = { [weak self] text in
            // begin editing next
            self?.repsTF.showKeyboard()
        }
        weightTF.textDidChange = { [weak self] text in
            self?.enableButtonIfNessesary()
        }
        view.addSubview(weightTF)

        repsTF.updateLabels(title: "Повторения", subtitle: model.exerciseGoal?.reps ?? "Пусто")
        repsTF.type = .numberPad
        repsTF.addToolbar()
        repsTF.shouldReturn = { [weak self] text in
            self?.noteTF.showKeyboard()
        }
        repsTF.textDidChange = { [weak self] text in
            self?.enableButtonIfNessesary()
        }
        view.addSubview(repsTF)

        noteTF.updateLabels(title: "Примечание", subtitle: model.exerciseGoal?.note ?? "Нет примечания")
        noteTF.shouldReturn = { [weak self] text in
//            self?.noteTF.hideKeyboard()
            self?.createSet()
        }
        noteTF.textDidChange = { [weak self] text in
            self?.enableButtonIfNessesary()
        }
        view.addSubview(noteTF)

        addButton.addTarget(self, action: #selector(createSet), for: .touchUpInside)
        view.addSubview(addButton)
        
        touchView.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        updateLastRegisteredSet()
        enableButtonIfNessesary()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    public func layout() {
        let offset = padding
        
        touchView.frame = self.view.bounds
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-keyboardHeight + offset)
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            make.height.equalTo(54)
        }
        
        noteTF.snp.makeConstraints { make in
            make.bottom.equalTo(addButton.snp.top).offset(-offset)
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            make.height.equalTo(46)
        }
        
        repsTF.snp.makeConstraints { make in
            make.bottom.equalTo(noteTF.snp.top).offset(-10)
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            make.height.equalTo(46)
        }
        
        weightTF.snp.makeConstraints { make in
            make.bottom.equalTo(repsTF.snp.top).offset(-10)
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            make.height.equalTo(46)
        }
        
        bg.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(weightTF.snp.top).offset(-offset*2)
        }
        bg.roundCorners(.Top, radius: 13)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        self.weightTF.showKeyboard()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    
    public func present(on vc: UIViewController) {
        vc.present(self, animated: true)
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
    
    private func enableButtonIfNessesary() {
        if !(weightTF.text ?? "").isEmpty &&
            !(repsTF.text ?? "").isEmpty {
            // Enable button
            addButton.isEnabled = true
        } else {
            // Disable button
            addButton.isEnabled = false
        }
    }

    private func updateLastRegisteredSet() {
        let request = SetEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        do {
            let lastRegisteredSets = try CoreDataManager.shared.context.fetch(request)
            if let date = lastRegisteredSets.first?.date, Date.isToday(date) {
                self.lastSet = lastRegisteredSets.first
            }
        } catch {
            CoreDataManager.shared.logFetchEntityError(
                methodName: #function,
                className: String(describing: self)
            )
        }

        // Update UI according to lastSet
        if let lastSet {
            weightTF.text = "\(lastSet.weight)"
            repsTF.text = "\(lastSet.reps)"
            noteTF.text = lastSet.note
        }
    }
}

// MARK: @objc
private extension AddSetController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.keyboardHeight = keyboardFrame.cgRectValue.height
                self.layout()
            }
        }
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }

    /// Create SetEntity
    /// Assign text fields texts to SetEntity properties
    /// Save entity to core data
    /// Dismiss vc
    @objc func createSet() {
        let newEntity = SetEntity(context: CoreDataManager.shared.context)
        newEntity.date = Date()
        newEntity.id = UUID()
        newEntity.weight = Float(weightTF.text ?? "") ?? 0
        newEntity.reps = Int32(repsTF.text ?? "") ?? 0
        newEntity.note = noteTF.text

        model.insertIntoSets(newEntity, at: 0)
        CoreDataManager.shared.saveContext()

        self.dismissVC()
        self.dismissedWithBlock?(newEntity)
    }
}
