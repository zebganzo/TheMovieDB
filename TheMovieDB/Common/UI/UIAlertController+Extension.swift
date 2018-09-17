//
//  UIAlertController+Extension.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 17.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlert(title: String?, message: String?, animated: Bool = true, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alertController.show(animated: true, completion: completion)
    }

    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController {
            visibleViewController.present(self, animated: animated, completion: completion)
        }
    }
}

extension UIWindow {

    var visibleViewController: UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        return visibleViewController(for: rootViewController)
    }

    private func nextOnStack(for controller: UIViewController) -> UIViewController? {
        if let presented = controller.presentedViewController {
            return presented
        }

        if let navigationController = controller as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = controller as? UITabBarController {
            return (tabBarController.selectedViewController ?? tabBarController.presentedViewController)
        }

        return nil
    }

    private func visibleViewController(for controller: UIViewController) -> UIViewController {
        if let nextOnStackViewController = self.nextOnStack(for: controller) {
            return visibleViewController(for: nextOnStackViewController)
        } else {
            return controller
        }
    }
}
