//
//  ExercisePropertiesController.swift
//  Rockout
//
//  Created by Kostya Lee on 18/12/23.
//

import Foundation
import UIKit
import SnapKit

public enum ExerciseProperty: String, CaseIterable {
    public static var allCases: [ExerciseProperty] {
        return [.sets, .reps, .weight, .restTime, .note]
    }
    case sets, reps, weight, restTime, note, none
}

public class ExercisePropertiesController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellReuseId = "cell"
    private var button = UIButton()

    private let pickTimeController = PickTimeController()

    private var items = ExerciseProperty.allCases

    private var model: ExerciseGoalEntity

    init(model: ExerciseGoalEntity) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }

    public func initViews() {
        view.backgroundColor = .background
        hideKeyboardWhenTappedAround()
        
        title = model.exerciseConfig?.exerciseName
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = Strings.backButtonTitle
        
        pickTimeController.pickedTime = { [weak self] time in
            self?.editModel(with: .restTime, input: time)
            self?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .bottomSeparatorColor
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.register(ExercisePropertyCell.self, forCellReuseIdentifier: cellReuseId)
        self.view.addSubview(tableView)
        
        var config = UIButton.Configuration.filled()
        config.title = "Сохранить"
        button.configuration = config
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    public func layout() {
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(view.frameWidth - padding*2)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-padding*2)
        }
    }
}

extension ExercisePropertiesController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? ExercisePropertyCell {

            cell.set(items[indexPath.row])
            cell.selectionStyle = .none
            cell.pickRestTime = { [weak self] in
                self?.pickTimeController.show()
            }
            cell.endedEditingClosure = { [weak self] text in
                guard let self else { return }
                self.editModel(with: items[indexPath.row], input: text)
            }
            
            // Fill in existing values if nessesary
            switch items[indexPath.row] {
            case .note:
                if model.note.safe() != "" {
                    cell.endedEditing(textFieldText: model.note)
                }
            case .reps:
                if model.reps.safe() != "" {
                    cell.endedEditing(textFieldText: model.reps)
                }
            case .sets:
                if model.sets.safe() != "" {
                    cell.endedEditing(textFieldText: model.sets)
                }
            case .weight:
                if model.weight.safe() != "" {
                    cell.endedEditing(textFieldText: model.weight)
                }
            case .restTime:
                if model.restTime != 0 {
                    cell.fillRest("\(SharedDataManager.getConvertedRestTime(model.restTime))")
                }
            case .none:
                break
            }
            return cell
        }
        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Введите количество подходов, вес, кол-во повторений и время отдыха для этого упражнения"
    }

    private func editModel(with property: ExerciseProperty, input: Any) {
        switch property {
        case .sets:
            model.sets = input as? String
        case .reps:
            model.reps = input as? String
        case .weight:
            model.weight = input as? String
        case .restTime:
            if let intValue = input as? Int {
                self.model.restTime = Int16(exactly: intValue) ?? 0
            }
        case .note:
            model.note = input as? String
        case .none:
            return
        }
    }
}

// MARK: Helper functions
extension ExercisePropertiesController {
    @objc private func buttonTapped() {
        CoreDataManager.shared.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
}
