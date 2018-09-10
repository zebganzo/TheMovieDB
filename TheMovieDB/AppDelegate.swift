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

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let httpLayer = HTTPLayer(apiKey: "2696829a81b1b5827d515ff121700838", baseURL: "http://api.themoviedb.org", version: 3)
        let endpoint = Endpoint.search("Batman", 1)
        httpLayer?.request(at: endpoint) { result in
            switch result {
            case .success(let data):
                let body = String(decoding: data, as: UTF8.self)
                print("Body \(body)")
            case .failure(let error):
                print("Error \(error)")
            }
        }

        return true
    }
}
