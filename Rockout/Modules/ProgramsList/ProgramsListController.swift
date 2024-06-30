//
//  ProgramsListViewController.swift
//  Rockout
//
//  Created by Kostya Lee on 30/09/23.
//

import UIKit
import SnapKit
public class ProgramsListController: UIViewController {
    
    private let newProgramButton = UIButton()
    private var searchController = UISearchController(searchResultsController: nil)
    
    private let tableView = UITableView()
    private let emptyView = ProgramsListEmptyView()
    
    private var originItems: [ProgramEntity] = []
    private var items: [ProgramEntity] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        presentWorkoutAlertIfNeeded()
        makeUpperased()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowTabBar()
        fetchPrograms()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLayoutSubviews() {
        layout()
    }
    
    private func presentWorkoutAlertIfNeeded() {
        // id of DayEntity
        if let id = UserDefaultsManager.getLastWorkoutId() {
            guard let entity = CoreDataManager.shared.getDayWithId(id: id) else { return }
            self.presentAlert(
                title: "\(entity.program?.name ?? "") \(entity.name ?? "")",
                message: "Продолжить тренировку?",
                actionBlock: { // Pressed on "yes"
                    self.animateHideTabBar()
                    let dayController = ExercisesListConfigurationController(model: entity, startWorkout: true)
                    self.navigationController?.pushViewController(dayController, animated: true)
                }, rejectBlock: {
                    UserDefaultsManager.setLastWorkoutId(nil)
                    UserDefaultsManager.setWorkoutStarted(false)
                }
            )
        }
    }
}

// MARK: UI
extension ProgramsListController {
    
    private func initViews() {
        view.backgroundColor = .background
        
        navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        title = Strings.workoutProgramsListTitle
        
        newProgramButton.setImage(.newProgramIcon, for: .normal)
        newProgramButton.addTarget(self, action: #selector(newProgramTapped), for: .touchUpInside)

        let rightItem: UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = newProgramButton
        navigationItem.rightBarButtonItem = rightItem
        
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = Strings.workoutProgramsListSearchbarPlaceholder
        navigationItem.searchController = searchController
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .bottomSeparatorColor
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.register(ProgramsListCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        view.addSubview(emptyView)
    }
    
    private func layout() {
        newProgramButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        tableView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
            make.size.equalTo(view.size)
        }

        emptyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(ProgramsListEmptyView.height())
            make.center.equalToSuperview()
        }
    }

    /// If items array is empty then show empty label
    private func checkIfEmpty() {
        if items.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }

    @objc func newProgramTapped() {
        let vc = CreateProgramController()
        vc.dismissed = { [weak self] model in
            // Once creation complete, new controller will be opened
            self?.navigationController?.pushViewController(DaysListController(model: model), animated: true)
        }
        self.present(vc, animated: true)
    }
}

extension ProgramsListController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // filter items from origin items by searchText (name, description)
        items = originItems.filter({
            $0.name?.lowercased().contains(searchText.lowercased()) ?? false ||
            $0.desc?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        tableView.reloadData()
        // reload data
    }
}

// MARK: Core data Management
extension ProgramsListController {
    private func fetchPrograms() {
        do {
            let allPrograms = try CoreDataManager.shared.context.fetch(
                ProgramEntity.fetchRequest()
            )
            self.originItems = allPrograms
            self.items = allPrograms
            self.tableView.reloadData()
            checkIfEmpty()
        } catch {
            CoreDataManager.shared.logFetchEntityError(
                methodName: #function,
                className: String(describing: type(of: self))
            )
        }
    }
}

// MARK: Table View Delegate and Data source
extension ProgramsListController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProgramsListCell {
            cell.selectionStyle = .none
            cell.update(items[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130.0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DaysListController(model: items[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
