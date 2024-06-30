//
//  DaysListController.swift
//  Rockout
//
//  Created by Kostya Lee on 02/10/23.
//

import UIKit
import SnapKit
import CoreData

public class DaysListController: UIViewController {
    
    private let emptyView = DaysListEmptyView()
    private let tableView = UITableView()
    private lazy var header = DaysListTableHeaderView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: view.frameWidth,
            height: view.frameWidth
        )
    )

    var items = [DayEntity]()
    private let reuseId = "DaysListCell"
    
    private var model: ProgramEntity

    /// Чтобы не запрашивать повторно каждый раз обьекты, все обьекты одного типа будут храниться здесь и сортироваться где нужно
    private var allExerciseDataEntities = [ExerciseDataEntity]()

    init(model: ProgramEntity) {
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateHideTabBar()
        reloadData()
        fetchExerciseEntities()
        updateHeader()
    }

    public override func viewDidLayoutSubviews() {
        layout()
    }
}

// MARK: UI
extension DaysListController {
    private func initViews() {
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(presentActionSheet)
        )
        navigationItem.rightBarButtonItem = editButton
        
        view.backgroundColor = .background
        self.hidesBottomBarWhenPushed = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(DaysListCell.self, forCellReuseIdentifier: reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        view.addSubview(tableView)

        header.imageView.backgroundColor = .systemGray4
        tableView.tableHeaderView = header
        header.buttonTappedClosure = { [weak self] in
            self?.showEditController()
        }

        self.view.addSubview(emptyView)
        emptyView.action = { [weak self] in
            self?.showAlertWithTextField()
        }
        emptyView.isHidden = true
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.height.equalTo(emptyView.getHeight())
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: Helper functions
private extension DaysListController {
    private func checkIfEmpty() {
        if items.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }

    /// Action sheet for navigation right bar button
    @objc private func presentActionSheet() {
        let alert = UIAlertController(title: "Выберите вариант", message: "", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Добавить день", style: .default, handler: { [weak self] (UIAlertAction) in
            self?.showAlertWithTextField()
        }))
        
        alert.addAction(UIAlertAction(title: "Изменить программу", style: .default, handler: { [weak self] (UIAlertAction) in
            self?.showEditController()
        }))

        alert.addAction(UIAlertAction(title: "Удалить программу", style: .destructive, handler: { [weak self] (UIAlertAction) in
            self?.showDeleteProgramAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        //alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }

    /// Presents alert with text field once "Add day" menu item is selected
    private func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Добавить день", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        let okayAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let textField = alertController.textFields?.first, let text = textField.text {
                self?.addDay(with: text)
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okayAction)

        present(alertController, animated: true, completion: nil)
    }

    /// Called when "Edit program menu item is selected"
    private func showEditController() {
        let vc = CreateProgramController(model: self.model)
        vc.dismissed = { [weak self] model in
            self?.model = model
            self?.updateHeader()
            self?.reloadData()
        }
        vc.present(on: self)
    }

    /// Presents alert once "Delete program" menu item is selected
    func showDeleteProgramAlert() {
        let alertController = UIAlertController(
            title: "Удалить программу",
            message: "Вы уверены что хотите удалить программу?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let okayAction = UIAlertAction(title: "Да", style: .default) { [weak self] action in
            self?.deleteProgram()
            self?.navigationController?.popViewController(animated: true)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okayAction)

        present(alertController, animated: true, completion: nil)
    }

    private func showDeleteDayAlert(with indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Удалить день",
            message: "Вы уверены что хотите удалить день?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let okayAction = UIAlertAction(title: "Да", style: .default) { [weak self] action in
            guard let self else { return }
            self.deleteDay(indexPath)
            self.checkIfEmpty()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okayAction)

        present(alertController, animated: true, completion: nil)
    }

    private func updateHeader() {
        if model.image != nil {
            self.header.update(self.model)
            tableView.reloadData()
        } else {
            self.title = self.model.name
            header.frame = .zero
            header.isHidden = true
            tableView.reloadData()
        }
    }

    private func showTitleInfo(model: DayEntity) {
        let alertController = UIAlertController(
            title: model.name ?? "",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "oк", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}

// MARK: Core Data Management
extension DaysListController {
    public func fetchExerciseEntities() {
        do {
            self.allExerciseDataEntities = try CoreDataManager.shared.context.fetch(ExerciseDataEntity.fetchRequest())
        } catch {
            CoreDataManager.shared.logFetchEntityError(
                methodName: #function,
                className: String(describing: type(of: self))
            )
        }
    }

    private func reloadData() {
        if let unwrappedList = model.days?.array as? [DayEntity] {
            self.items = unwrappedList
        }
        tableView.reloadData()
        checkIfEmpty()
    }

    private func addDay(with name: String) {
        do {
            let new = DayEntity(context: CoreDataManager.shared.context)
            new.name = name
            new.createdAt = Date()
            new.id = UUID()
            model.addToDays(new)

            try CoreDataManager.shared.context.save()
            reloadData()
        } catch {
            CoreDataManager.shared.logSaveEntityError(
                methodName: #function,
                className: String(describing: type(of: self))
            )
        }
    }

    /// Permanently deletes workout program
    private func deleteProgram() {
        do {
            CoreDataManager.shared.context.delete(self.model)
            try CoreDataManager.shared.context.save()
        } catch {
            CoreDataManager.shared.logSaveEntityError(
                methodName: #function,
                className: String(describing: type(of: self))
            )
        }
    }

    private func deleteDay(_ indexPath: IndexPath) {
        do {
            // Delete the entity from the managed object context
            CoreDataManager.shared.context.delete(items[indexPath.row])
            
            // Save the changes to persist the deletion
            try CoreDataManager.shared.context.save()
        } catch {
            CoreDataManager.shared.logSaveEntityError(
                methodName: #function,
                className: String(describing: self)
            )
        }
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}

// MARK: Table view
extension DaysListController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? DaysListCell {
            cell.update(
                withModel: items[indexPath.row], 
                allExercises: self.allExerciseDataEntities
            )
            cell.selectedTitleClosure = { [weak self] in
                // Present info alert
                guard let self else { return }
                self.showTitleInfo(model: self.items[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ExercisesListConfigurationController(
            model: items[indexPath.row]
        )
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        calculateCellHeight(index: indexPath.row)
    }

    private func calculateCellHeight(index: Int) -> CGFloat {
        let count = items[index].exerciseConfigs?.count ?? 0

        if count > 4 {
            return 210
        } else if count == 4 {
            return 200
        } else if count == 3 {
            return 170
        } else if count == 2 {
            return 150
        } else if count == 0 {
            return 140
        }
        return 120
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a 'Delete' action
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            // Handle deletion here
            // For example, remove the item from your data source and update the table view
            self.showDeleteDayAlert(with: indexPath)
            
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
}

extension DaysListController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let header = tableView.tableHeaderView as? DaysListTableHeaderView {
            header.scrollViewDidScroll(scrollView: tableView)
        }
    }
}
