//
//  HistoryDayController.swift
//  Rockout
//
//  Created by Kostya Lee on 26/05/24.
//

import Foundation
import UIKit
import SnapKit
import CoreData

public class HistoryDayController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let emptyLabel = UILabel() /// Appears when tableview is empty

    // sets will be sorted by date in tableview
    private var items = [[SetEntity]]()
    private var sectionTitles = [String]()
    
    private let formatter = DateFormatter()
    
    private var date: Date

    init(date: Date = Date()) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        reload()
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

extension HistoryDayController {
    private func initViews() {
        view.backgroundColor = .background

        formatter.dateFormat = "E, d MMMM yyyy"
        title = formatter.string(from: date)
        navigationItem.backButtonTitle = Strings.backButtonTitle

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ExerciseConfigurationCell.self, forCellReuseIdentifier: ExerciseConfigurationCell.id)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        emptyLabel.text = "Пусто"
        emptyLabel.font = .systemFont(ofSize: 20, weight: .light)
        emptyLabel.textColor = .description
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        view.addSubview(emptyLabel)
    }
    
    private func layout() {

        tableView.frame = self.view.bounds
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 70, right: 0)

        emptyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.height.equalTo(emptyLabel.textHeight(view.frame.width - padding*2))
            make.center.equalToSuperview()
        }
    }
}

extension HistoryDayController {
    
    private func checkIfEmpty() {
        if items.isEmpty {
            /// show empty view + hide main view
            emptyLabel.isHidden = false
        } else {
            /// hide empty view + show main view
            emptyLabel.isHidden = true
        }
    }

    private func reload() {
        loadSets { [weak self] sets in
            guard let self, let sets else { return }
            DispatchQueue.main.async {
                self.items = self.sortNamesIntoSections(sets: sets)
                self.checkIfEmpty()
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadSets(_ completion: (([SetEntity]?) -> Void)?) {
        
        let backgroundContext = CoreDataManager.shared.backgroundContext
        backgroundContext.perform { [weak self] in
            guard let self else { return }

            // get the current calendar
            let calendar = Calendar.current
            // get the start of the day of the selected date
            let startDate = calendar.startOfDay(for: date)
            // get the start of the day after the selected date
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            // create a predicate to filter between start date and end date
            
            let predicate = NSPredicate(
                format: "date >= %@ AND date < %@",
                startDate as NSDate,
                endDate as NSDate
            )
            let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                // Execute the fetch request
                let results = try CoreDataManager.shared.context.fetch(fetchRequest)
                completion?(results)
            } catch {
                CoreDataManager.shared.logFetchEntityError(
                    methodName: #function,
                    className: String(describing: self)
                )
                completion?(nil)
            }
        }
    }

    private func sortNamesIntoSections(sets: [SetEntity]) -> [[SetEntity]] {
        var sectionsDictionary = [String: [SetEntity]]()
        
        // Iterate over the dates and group them by Exercise
        for set in sets {
            guard let name = set.exerciseConfig?.exerciseName else { continue }
            if var section = sectionsDictionary[name] {
                section.append(set)
                sectionsDictionary[name] = section
            } else {
                sectionsDictionary[name] = [set]
            }
        }
        
        // Sort the keys (days) of the dictionary
        let exerciseNames = sectionsDictionary.keys
        
        // Create an array of sections sorted by day
        var sections = [[SetEntity]]()
        for name in exerciseNames {
            if let section = sectionsDictionary[name] {
                sections.insert(section, at: 0)
                sectionTitles.insert(name, at: 0)
            }
        }
        
        return sections
    }
}

extension HistoryDayController : UITableViewDelegate, UITableViewDataSource {
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
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let label = UILabel()
        label.text = self.sectionTitles[section]
        label.font = .systemFont(ofSize: 15)
        let h = label.textHeight(view.frame.width - padding*2) + 10
        
        return h
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
