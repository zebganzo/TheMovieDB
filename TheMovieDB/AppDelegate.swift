//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 09.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    private var appManager: AppManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        do {
            self.appManager = try AppManager()
        } catch AppManagerError.initialization(let error){
            UIAlertController.showAlert(title: "Initialization error", message: error.localizedDescription, animated: true)
        } catch let error {
            UIAlertController.showAlert(title: "Unknown error", message: error.localizedDescription, animated: true)
        }

        self.window?.rootViewController = self.appManager?.presenterManager.rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }
}
