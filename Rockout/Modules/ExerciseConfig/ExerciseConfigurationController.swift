//
//  ExerciseConfigurationController.swift
//  Rockout
//
//  Created by Kostya Lee on 19/10/23.
//

import UIKit
import SnapKit
import CoreData
import UIKit

public class ExerciseConfigurationController: SwipableViewController {
    
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let emptyView = ExerciseConfigurationEmptyView() /// Appears when tableview is empty
    
    private let glassButton = GlassButton(
        style: .systemUltraThinMaterialDark,
        title: "Новый подход",
        image: UIImage(named: "plus_circle")
    )

    private let board = ExerciseGoalsBoardView()

    // sets will be sorted by date in tableview
    private var items = [[SetEntity]]()
    private var sectionTitles = [String]()
    
    private var model: ExerciseConfigEntity
    private let formatter = DateFormatter()

    init(model: ExerciseConfigEntity) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        reload()
        board.updateModel(model, date: sectionTitles.first)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfEmpty()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
}

// MARK: UI
extension ExerciseConfigurationController {
    private func initViews() {
        view.backgroundColor = .background

        title = "Ваши подходы"
        navigationItem.backButtonTitle = Strings.backButtonTitle
        navigationItem.rightBarButtonItem = nil

        titleLabel.text = model.exerciseName
        titleLabel.textColor = .primaryLabel
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ExerciseConfigurationCell.self, forCellReuseIdentifier: ExerciseConfigurationCell.id)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        board.initViews()
        board.tappedClosure = { [weak self] in
            self?.boardTapped()
        }
        board.timerButtonTappedAction = { [weak self] in
            self?.timerButtonTapped()
        }
        board.percentageButtonTappedAction = { [weak self] in
            self?.percentageButtonTapped()
        }

        emptyView.action = { [weak self] in
            self?.presentAddSetVC()
        }
        view.addSubview(emptyView)

        glassButton.tapped = {
            self.presentAddSetVC()
        }
        view.addSubview(glassButton)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.top.equalTo(CGFloat.topSafePadding + 60.0)
            make.width.equalTo(view.frameWidth - padding*2)
        }

        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        emptyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(emptyView.getHeight())
            make.center.equalToSuperview()
        }

        glassButton.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-padding*2)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-padding*2)
        }
    }
}

// MARK: Helper functions
extension ExerciseConfigurationController {

    private func checkIfEmpty() {
        if items.isEmpty {
            /// show empty view + hide main view
            emptyView.isHidden = false
            titleLabel.isHidden = true
            board.isHidden = true
            glassButton.isHidden = true
        } else {
            /// hide empty view + show main view
            emptyView.isHidden = true
            titleLabel.isHidden = false
            board.isHidden = false
            glassButton.isHidden = false
        }
    }

    private func reload() {
        let unsortedArray = model.sets?.array as? [SetEntity] ?? []
        self.items = sortDatesIntoSections(sets: unsortedArray)
        self.checkIfEmpty()
//        tableView.reloadSections([0], with: .automatic)
//        tableView.reloadData()
        tableView.reloadData()
    }

    private func sortDatesIntoSections(sets: [SetEntity]) -> [[SetEntity]] {
        var sectionsDictionary = [Date: [SetEntity]]()
        
        // Iterate over the dates and group them by day
        for set in sets {
            guard let date = set.date else { continue }
            let calendar = Calendar.current
            let day = calendar.startOfDay(for: date)
            if var section = sectionsDictionary[day] {
                section.append(set)
                sectionsDictionary[day] = section
            } else {
                sectionsDictionary[day] = [set]
            }
        }
        
        // Sort the keys (days) of the dictionary
        let sortedDays = sectionsDictionary.keys.sorted()
        
        // Create an array of sections sorted by day
        var sections = [[SetEntity]]()
        for day in sortedDays {
            if let section = sectionsDictionary[day] {
                sections.insert(section, at: 0)
                configureSectionTitle(with: day)
            }
        }
        
        return sections
    }

    // convert date to string and append to sectionTitles
    private func configureSectionTitle(with date: Date) {
        formatter.dateFormat = dateFormatForSections
        formatter.locale = Locale(identifier: "ru_RU")
        if Date.isToday(date) { 
            sectionTitles.insert("Сегодня", at: 0)
        } else {
            sectionTitles.insert(formatter.string(from: date), at: 0)
        }
    }

    private func boardTapped() {
        // Present info alert
        let emptyString = "Не указано"
        let rest = SharedDataManager.getConvertedRestTime(model.exerciseGoal?.restTime)
        let message =
        """
        - Вес: \(model.exerciseGoal?.weight ?? emptyString)
        - Кол-во повторений: \(model.exerciseGoal?.reps ?? emptyString)
        - Кол-во подходов: \(model.exerciseGoal?.sets ?? emptyString)
        - Время отдыха: \(rest == "0" ? emptyString : "\(rest)")
        """
        presentInfoAlert(title: "Ваши цели на этой тренировке:", message: message)
    }

    private func deleteSet(_ indexPath: IndexPath) {
        do {
            // Delete the entity from the managed object context
            CoreDataManager.shared.context.delete(items[indexPath.section][indexPath.row])
            
            // Save the changes to persist the deletion
            try CoreDataManager.shared.context.save()
        } catch {
            CoreDataManager.shared.logSaveEntityError(
                methodName: #function,
                className: String(describing: self)
            )
        }
        items[indexPath.section].remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}

// MARK: @objc Button handling
private extension ExerciseConfigurationController {

    func presentAddSetVC() {
        let vc = AddSetController(model: model)
        vc.dismissedWithBlock = { [weak self] _ in
            self?.reload()
        }
        vc.present(on: self)
    }

    func timerButtonTapped() {
        showTimer(didEndCountdown: { [weak self] initialTime in
            guard let self else { return }
            guard var rests = model.rests as? [Int16] else {
                return // Handle if the transformable property isn't an array of Int16
            }
            rests.append(Int16(initialTime))
            model.rests = rests as NSObject
            CoreDataManager.shared.saveContext()
        })
    }

    func percentageButtonTapped() {
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Вычислить процент", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Значение"
        }
        alertController.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "%"
        }
        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "ОК", style: .default) { _ in
            // this code runs when the user hits the "ОК" button
            if let valueString = alertController.textFields?[0].text,
               let percentageString = alertController.textFields?[1].text {
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self else { return }
                    let value = (Double(valueString) ?? 1.0) * ((Double(percentageString)  ?? 1.0) / 100.0)
                    let infoController = UIAlertController(title: "\(value)", message: nil, preferredStyle: .alert)
                    infoController.addAction(
                        UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
                    )
                    self.present(infoController, animated: true, completion: nil)
                }
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ExerciseConfigurationController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseConfigurationCell.id, for: indexPath) as? ExerciseConfigurationCell {
            cell.updateModel(model: items[indexPath.section][indexPath.row])
            cell.tappedOnTitle = { [weak self] in
                guard let self else { return }
                self.presentSetInfo(model: items[indexPath.section][indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].count
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a 'Delete' action
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            // Handle deletion here
            // For example, remove the item from your data source and update the table view
            self.showDeleteSetAlert(with: indexPath)
            
            // Call the completion handler to dismiss the action button
            completionHandler(true)
        }

        // Customize the appearance of the 'Delete' action
        deleteAction.image = UIImage(systemName: "trash")
        
        // Create a swipe actions configuration with the 'Delete' action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        // Return the swipe actions configuration for the specific row
        return swipeConfiguration
    }
    
    private func showDeleteSetAlert(with indexPath: IndexPath) {
        presentAlert(
            title: "Удалить подход",
            message: "Вы уверены что хотите удалить упражнение?",
            actionBlock: { [weak self] in
                self?.deleteSet(indexPath)
            }
        )
    }

    private func presentSetInfo(model: SetEntity) {
        var weightIndicator = ""
        let indicator = PreferredWeightIndicator(rawValue: UserDefaultsManager.getPreferredWeightIndicator())
        switch indicator ?? .kg {
        case .kg:
            weightIndicator = "кг"
        case .lbs:
            weightIndicator = "фунты"
        }
        let message = "\(model.weight) \(weightIndicator) на \(model.reps) повторений" // Ex: 50 кг на 12 повторений
        let alertController = UIAlertController(
            title: "Информация о подходе",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return board
        }
        return UITableViewHeaderFooterView()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return board.getHeight() + padding
        }
        return 24.0
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor(hex: "#878787")
            header.textLabel?.font = .systemFont(ofSize: 15)
        }
    }
}
