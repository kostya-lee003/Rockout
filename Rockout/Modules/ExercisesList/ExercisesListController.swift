//
//  ExercisesListController.swift
//  Rockout
//
//  Created by Kostya Lee on 09/10/23.
//

import UIKit
import SnapKit
import CoreData
import os

public class ExercisesListController: SwipableViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellReuseId = "cell"
    private var items = [ExerciseDataEntity]()
    private let searchBarController = UISearchController(searchResultsController: nil)

    /// All items + modified by search (filtered)
    private var filteredItems = [ExerciseDataEntity]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadExercises()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowTabBar()
    }
}

// MARK: UI
extension ExercisesListController {
    
    private func initViews() {
        view.backgroundColor = .background
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = "Все упражнения"
        searchBarController.searchBar.delegate = self

        navigationItem.backButtonTitle = Strings.backButtonTitle
        navigationItem.searchController = searchBarController

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .bottomSeparatorColor
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.register(ExerciseListCell.self, forCellReuseIdentifier: cellReuseId)
        self.view.addSubview(tableView)
    }

    private func layout() {
        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

extension ExercisesListController {
    /// Loads exercises from data base
    private func loadExercises(completion: CompletionHandler = nil) {
        do {
            let items = try CoreDataManager.shared.context.fetch(ExerciseDataEntity.fetchRequest())
            self.items = items
            self.filteredItems = items
        } catch {
            print("couldn't load data from memory")
        }
        self.tableView.reloadData()
        completion?()
    }
}

// MARK: Table View
extension ExercisesListController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? ExerciseListCell {
            cell.textLabel?.text = namesDict[filteredItems[indexPath.row].id ?? ""]
            cell.selectionStyle = .none
            cell.selectedClosure = { [weak self] in
                guard let self else { return }
                self.selectedCell(index: indexPath.row)
            }
            cell.hideEditButton()
            return cell
        }
        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }

    private func selectedCell(index: Int) {
        let controller = ExerciseInfoController(filteredItems[index])
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: Search
extension ExercisesListController: UISearchBarDelegate {
    public func getFilteredData(using searchedText: String = String()) {
        let filteredListData: [ExerciseDataEntity] = items.filter({ (object) -> Bool in
            searchedText.isEmpty ? true : (object.name ?? "").lowercased().contains(searchedText.lowercased())
        })
        filteredItems = filteredListData
        tableView.reloadData()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getFilteredData(using: searchBar.text ?? String())
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        getFilteredData()
    }
}
