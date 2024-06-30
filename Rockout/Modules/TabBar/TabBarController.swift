//
//  TabBarController.swift
//  Rockout
//
//  Created by Kostya Lee on 17/01/24.
//

import Foundation
import UIKit

public class TabBarController: UITabBarController {
    public override func viewDidLoad() {
        setupTabs()
    }

    private func setupTabs() {
        let vc1 = ProgramsListController()
        let nav1 = createNavigationController(
            with: Strings.workoutProgramsListTitle,
            and: UIImage(systemName: "menucard"), // play.square.fill  r.square.on.square
            vc: vc1
        )
        let vc2 = ExercisesListController()
        let nav2 = createNavigationController(
            with: "Все упражнения",
            and: UIImage(systemName: "dumbbell"),
            vc: vc2
        )
        var vc3: UIViewController
        if #available(iOS 16.0, *) {
            vc3 = HistoryController()
        } else {
            vc3 = HistoryDayController()
        }
        let nav3 = createNavigationController(
            with: "История",
            and: UIImage(systemName: "arrow.clockwise"),
            vc: vc3
        )
        self.setViewControllers([nav1, nav2, nav3], animated: false)
    }

    private func createNavigationController(
        with title: String,
        and image: UIImage?,
        vc: UIViewController
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}
