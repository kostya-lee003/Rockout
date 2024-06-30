//
//  ExerciseSelectionController.swift
//  Rockout
//
//  Created by Kostya Lee on 18/12/23.
//

import Foundation
import UIKit
import SnapKit

public class ExerciseSelectionController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellReuseId = "ExerciseSelectionCell"
    private let button = GlassButton(style: .systemUltraThinMaterialDark, title: "Добавить упражнения", image: nil)
    private let searchBar = UISearchBar()

    /// All items / exercises
    private var items = [ExerciseDataEntity]()

    /// All items + modified by search (filtered)
    private var filteredItems = [ExerciseDataEntity]()

    /// Items selected by user
    private var selectedItems = [ExerciseDataEntity]()
    
    public var pickedExercises: (([ExerciseDataEntity]) -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadExercises()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
}

// MARK: UI
extension ExerciseSelectionController {
    
    private func initViews() {
        view.backgroundColor = .background
        
        title = "Выберите упражнения"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = Strings.backButtonTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .bottomSeparatorColor
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.register(ExerciseSelectionCell.self, forCellReuseIdentifier: cellReuseId)
        self.view.addSubview(tableView)
        
        searchBar.placeholder = "Искать упражнения"
        searchBar.delegate = self
//        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .background
//        searchBar.showsCancelButton = true
        searchBar.isTranslucent = true
        searchBar.searchBarStyle = .minimal
        self.view.addSubview(searchBar)

        button.tapped = { [weak self] in
            guard let self, !self.selectedItems.isEmpty else { return }
            self.dismiss(animated: true) { [weak self] in
                guard let self else { return }
                self.pickedExercises?(self.selectedItems)
            }
        }
        self.view.addSubview(button)
    }

    private func layout() {
        
        searchBar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.top.equalToSuperview().offset(padding)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 80.0, right: 0.0)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(view.frameWidth - padding*2)
            make.height.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-padding*2)
        }
    }
}

// MARK: Table View management
extension ExerciseSelectionController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? ExerciseSelectionCell {
            cell.cellIsSelected = selectedItems.contains(filteredItems[indexPath.row])
            cell.textLabel?.text = filteredItems[indexPath.row].name
            cell.selectionStyle = .none
            cell.selectedClosure = { [weak self] in
                self?.tableView(tableView, didSelectRowAt: indexPath)
            }
            cell.showInfo = { [weak self] in
                guard let self else { return }
                self.presentInfoAlert(
                    title: items[indexPath.row].name ?? "Нет названия",
                    message: items[indexPath.row].desc ?? "Нет описания"
                )
            }
            return cell
        }
        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedItems.contains(filteredItems[indexPath.row]) {
            // Unselect and remove from selectedItems array
            // Remove object from array using filter function
            selectedItems = selectedItems.filter { $0 !== filteredItems[indexPath.row] }
        } else {
            // Select item
            selectedItems.append(filteredItems[indexPath.row])
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }
}

// MARK: Core Data
extension ExerciseSelectionController {
    /// Loads exercises from data base
    private func loadExercises(completion: CompletionHandler = nil) {
        do {
            let items = try CoreDataManager.shared.context.fetch(ExerciseDataEntity.fetchRequest())
            self.items = items
            self.filteredItems = items
        } catch {
            CoreDataManager.shared.logFetchEntityError(
                methodName: #function,
                className: String(describing: self)
            )
        }
        self.tableView.reloadData()
        completion?()
    }
}

// MARK: Search
extension ExerciseSelectionController: UISearchBarDelegate {
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
