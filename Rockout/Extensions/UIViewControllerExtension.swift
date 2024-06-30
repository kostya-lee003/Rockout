//
//  UIViewControllerExtension.swift
//  Rockout
//
//  Created by Kostya Lee on 30/09/23.
//

import UIKit

extension UIViewController {
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    public func animateShowTabBar() {
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.35) {
            self.tabBarController?.tabBar.alpha = 1
        }
    }
    
    public func animateHideTabBar() {
        UIView.animate(withDuration: 0.35, animations: {
            self.tabBarController?.tabBar.alpha = 0
        }, completion: { completed in
            if completed {
                self.tabBarController?.tabBar.isHidden = true
            }
        })
    }
}

extension UIViewController {
    public func presentAlert(
        title: String,
        message: String,
        actionBlock: CompletionHandler,
        rejectBlock: CompletionHandler = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            rejectBlock?()
        }
        let okayAction = UIAlertAction(title: "Да", style: .default) { action in
            actionBlock?()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okayAction)

        present(alertController, animated: true, completion: nil)
    }

    public func presentInfoAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "ок", style: .cancel, handler: nil)

        alertController.addAction(action)

        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
