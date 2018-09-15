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

    var presenter: Presenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        let apiKey = "2696829a81b1b5827d515ff121700838"
        let baseURL = "http://api.themoviedb.org"
        let version = 3

        let httpLayer = try! AuthenticatedHttpLayer.init(apiKey: apiKey, baseUrl: baseURL, version: version)
        let apiClient = APIClient(httpLayer: httpLayer)
        let movieSearchViewModel = MovieSearchViewModel(searchClient: apiClient)

        let router = Router(entryViewModel: .movieSearch(movieSearchViewModel))
        self.presenter = Presenter(router: router, navigationController: navigationController)

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
    }
}
