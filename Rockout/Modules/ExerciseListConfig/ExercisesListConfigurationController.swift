//
//  ExercisesListConfigurationController.swift
//  Rockout
//
//  Created by Kostya Lee on 09/10/23.
//

import UIKit
import SnapKit
import CoreData

public class ExercisesListConfigurationController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellReuseId = "cell"

    private var items: [ExerciseConfigEntity] = []

    private let button = GlassButton(
        style: .systemUltraThinMaterialDark,
        title: UserDefaultsManager.isWorkoutStarted() ? "Завершить тренировку" : "Начать тренировку",
        image: nil
    )

    private let emptyButton = UIButton()
    private let emptyLabel = UILabel()
    private let emptyTouchView = UIButton()

    private var model: DayEntity
    
    private var startWorkout: Bool

    init(model: DayEntity, startWorkout: Bool = false) {
        self.model = model
        self.startWorkout = startWorkout
        super.init(nibName: nil, bundle: nil)
        self.populateTable()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        if startWorkout {
            self.startWorkout(with: Date())
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

// MARK: UI
extension ExercisesListConfigurationController {
    
    private func initViews() {
        view.backgroundColor = .background
        
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        editButton.tintColor = .primaryTint
        navigationItem.rightBarButtonItem = editButton
        title = model.name
        
        navigationItem.backButtonTitle = Strings.backButtonTitle

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .bottomSeparatorColor
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.register(ExerciseListConfigCell.self, forCellReuseIdentifier: cellReuseId)
        self.view.addSubview(tableView)

        button.tapped = { [weak self] in
            self?.startStopWorkout()
        }
        self.view.addSubview(button)

        emptyLabel.text = "Добавьте упражнения которые будете выполнять на этой тренировке."
        emptyLabel.font = .systemFont(ofSize: 18)
        emptyLabel.textColor = .description
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        self.view.addSubview(emptyLabel)

        emptyButton.setImage(UIImage(named: "plus_rect"), for: .normal)
        self.view.addSubview(emptyButton)

        emptyTouchView.addTarget(self, action: #selector(showSelectionController), for: .touchUpInside)
        self.view.addSubview(emptyTouchView)
    }

    private func layout() {
        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 80.0, right: 0.0)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(view.frameWidth - padding*2)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-padding*2)
        }

        emptyButton.snp.makeConstraints { make in
            make.size.equalTo(65)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-35)
        }

        emptyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.centerY.equalToSuperview().offset(40)
        }
        
        emptyTouchView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(200)
            make.center.equalToSuperview()
        }
    }
}

// MARK: Helper functions
extension ExercisesListConfigurationController {

    // Start or stop workout
    private func startStopWorkout() {
        if UserDefaultsManager.isWorkoutStarted() {
            presentAlert(
                title: "Завершить тренировку",
                message: "Вы уверены что хотите завершить тренировку?",
                actionBlock: { [weak self] in
                    self?.endWorkout()
                }
            )
        } else {
            let vc = DatePickerController()
            vc.willDismissWithDate = { [weak self] pickedDate in
                self?.startWorkout(with: pickedDate)
            }
            self.present(vc, animated: true)
        }
    }

    private func checkIfEmpty() {
        if items.isEmpty {
            emptyLabel.isHidden = false
            emptyButton.isHidden = false
            emptyTouchView.isHidden = false
            tableView.isHidden = true
            button.isHidden = true
        } else {
            emptyLabel.isHidden = true
            emptyButton.isHidden = true
            emptyTouchView.isHidden = true
            tableView.isHidden = false
            button.isHidden = false
        }
    }

    /// Called when empty view is selected
    @objc func showSelectionController() {
        let vc = ExerciseSelectionController()
        vc.pickedExercises = { [weak self] pickedItems in
            guard let self else { return }
            pickedItems.forEach { exerciseData in
                let newConfig = ExerciseConfigEntity(context: CoreDataManager.shared.context)
                newConfig.id = UUID()
                newConfig.exerciseName = exerciseData.name
                newConfig.exerciseInfoId = exerciseData.id
                newConfig.sets = []
                newConfig.exerciseGoal = self.createEmptyGoal()
                self.model.addToExerciseConfigs(newConfig)
                self.items.append(newConfig)
                
                CoreDataManager.shared.saveContext()
            }
            self.tableView.reloadData()
            checkIfEmpty()
        }
        self.present(vc, animated: true)
    }

    @objc func editButtonTapped() {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)

        alert.addAction(
            UIAlertAction(
                title: "Добавить упражнения",
                style: .default,
                handler: { [weak self] (UIAlertAction) in
                    self?.showSelectionController()
            })
        )

        alert.addAction(
            UIAlertAction(
                title: "Удалить день",
                style: .destructive,
                handler: { [weak self] (UIAlertAction) in
                    guard let self else { return }
                    self.deleteEntireDayIfAllowed()
            })
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        //alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createEmptyGoal() -> ExerciseGoalEntity {
        let newGoal = ExerciseGoalEntity(context: CoreDataManager.shared.context)
        newGoal.id = UUID()
        return newGoal
    }
    
    private func showDeleteExerciseAlert(with indexPath: IndexPath) {
        presentAlert(
            title: "Удалить упражнение",
            message: "Вы уверены что хотите удалить упражнение?",
            actionBlock: { [weak self] in
                self?.deleteConfig(indexPath)
            }
        )
    }

    private func deleteConfig(_ indexPath: IndexPath) {
        do {
            // Delete the entity from the managed object context
            CoreDataManager.shared.context.delete(items[indexPath.row])
            
            // Save the changes to persist the deletion
            try CoreDataManager.shared.context.save()

            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)

            checkIfEmpty()
        } catch {
            CoreDataManager.shared.logSaveEntityError(
                methodName: #function,
                className: String(describing: self)
            )
        }
    }

    private func deleteEntireDayIfAllowed() {
        presentAlert(
            title: "Удалить день",
            message: "Вы уверены что хотите удалить \(model.name ?? "")?",
            actionBlock: { [weak self] in
                guard let self else { return }
                CoreDataManager.shared.context.delete(model)
                CoreDataManager.shared.saveContext()
                self.navigationController?.popViewController(animated: true)
            }
        )
    }

    private func startWorkout(with date: Date) {
        button.title = "Завершить тренировку"
        UserDefaultsManager.setWorkoutStarted(true)
        model.workoutStartedDate = date
        CoreDataManager.shared.saveContext()
        UserDefaultsManager.setLastWorkoutId(model.id?.uuidString)
    }

    private func endWorkout() {
        button.title = "Начать тренировку"
        CoreDataManager.shared.saveContext()
        UserDefaultsManager.setWorkoutStarted(false)
        UserDefaultsManager.setLastWorkoutId(nil)
        model.workoutEndedDate = Date()
        CoreDataManager.shared.saveContext()
        self.dismiss(animated: true)
    }
    
    func test() {
        /// Print:
        /// 'Workout program name - workout day name - exercise name - nimber of sets - num of reps - time'
        // Define the fetch request
        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()

        do {
            // Execute the fetch request
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            results.forEach { program in
                print("")
                print("")
                print(program.name)
                program.days?.array.forEach({ day in
                    guard let day = day as? DayEntity else {
                        fatalError("fell into guard: DayEntity")
                    }
                    print(day.name)
                    
                    day.exerciseConfigs?.array.forEach({ config in
                        guard let config = config as? ExerciseConfigEntity else {
                            fatalError("fell into guard: ExerciseConfigEntity")
                        }
                        print(config.exerciseName)
                        print(config.sets?.array.last)
                    })
                })
            }
            
        } catch {
            CoreDataManager.shared.logFetchEntityError(
                methodName: #function,
                className: String(describing: self)
            )
        }
    }
}

// MARK: Table View
extension ExercisesListConfigurationController: UITableViewDelegate, UITableViewDataSource {
    private func populateTable() {
        items.append(contentsOf: model.exerciseConfigs?.array as? [ExerciseConfigEntity] ?? [])
        tableView.reloadSections([0], with: .automatic)
        checkIfEmpty()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? ExerciseListConfigCell {
            cell.titleLabel.text = namesDict[items[indexPath.row].exerciseInfoId ?? ""]
            cell.subtitleLabel.text = getSubtitleText(with: items[indexPath.row].exerciseGoal)
            cell.selectionStyle = .none
            cell.editClosure = { [weak self] in
                guard let self, let goal = self.items[indexPath.row].exerciseGoal else { return }
                let vc = ExercisePropertiesController(model: goal)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaultsManager.isWorkoutStarted() {
            let controller = ExerciseConfigurationController(model: items[indexPath.row])
            navigationController?.pushViewController(controller, animated: true)
        } else {
            if let exerciseData = CoreDataManager.shared.fetchExerciseDataEntity(
                with: items[indexPath.row].exerciseInfoId ?? ""
            ) {
                let controller = ExerciseInfoController(exerciseData)
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a 'Delete' action
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            // Handle deletion here
            // For example, remove the item from your data source and update the table view
            self.showDeleteExerciseAlert(with: indexPath)
            
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

    /// Returns specific text according to model (ExerciseGoalEntity)
    private func getSubtitleText(with model: ExerciseGoalEntity?) -> String {
        guard let model else {
            NSLog(commonLogFormat, "ExerciseGoalEntity is nil, fix!!!")
            return "Пусто"
        }
        if model.reps.safe() != "" &&
            model.sets.safe() != "" {
            // Пример строки: 8-12 повторений x 3 подхода
            let repsContainsLetters = model.reps?.containsRussianLetters()
            let setsContainsLetters = model.sets?.containsRussianLetters()
            
            let repsString = repsContainsLetters ?? false ? model.reps.safe() : "\(model.reps.safe()) повторений"
            let setsString = setsContainsLetters ?? false ? model.sets.safe() : "\(model.sets.safe()) подходов"
            
            return "\(setsString) x \(repsString)"
        } else {
            // Either of reps, sets, weight, note, rest should not be nil, else return "Пусто"
            var nessesaryGoal = "Нет целей"
            if model.reps.safe() != "" {
                if model.reps.safe().containsRussianLetters() {
                    nessesaryGoal = model.reps.safe()
                } else {
                    nessesaryGoal = "\(model.reps.safe()) повторений"
                }
            } else if model.sets.safe() != "" {
                if model.sets.safe().containsRussianLetters() {
                    nessesaryGoal = model.sets.safe()
                } else {
                    nessesaryGoal = "\(model.sets.safe()) подходов"
                }
            } else if model.weight.safe() != "" {
                if model.weight.safe().containsRussianLetters() {
                    nessesaryGoal = model.weight.safe()
                } else {
                    let wIndicator = UserDefaultsManager.getPreferredWeightIndicator() == PreferredWeightIndicator.kg.rawValue ? "кг" : "фунтов"
                    nessesaryGoal = "\(model.weight.safe()) \(wIndicator)"
                }
            } else if model.note.safe() != "" {
                nessesaryGoal = model.note.safe()
            } else if model.restTime != 0 {
                nessesaryGoal = "Время отдыха - \(model.restTime)"
            }

            return nessesaryGoal
        }
    }
}

