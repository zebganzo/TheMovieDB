//
//  AppManager.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 16.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

class AppManager {

    let apiClient: ApiClientProtocol
    let storeClient: SuggestionsProtocol
    let presenterManager: PresenterManagerProtocol
    let routingManager: RoutingManagerProtocol

    init(apiClient: ApiClientProtocol? = nil
        , storeClient: SuggestionsProtocol? = nil
        , presenterManager: PresenterManagerProtocol? = nil
        , routingManager: RoutingManagerProtocol? = nil) {
        self.apiClient = type(of: self).buildApiClient(apiClient: apiClient)
        self.storeClient = type(of: self).buildStoreClient(storeClient: storeClient)
        self.routingManager =  type(of: self).buildRoutingManager(routingManager: routingManager, searchClient: self.apiClient, suggestionsClient: self.storeClient, imageClient: self.apiClient)
        self.presenterManager = type(of: self).buildPresenterManager(presenterManager: presenterManager, routingManager: self.routingManager)

        self.presenterManager.perform(action: PresenterManagerAction.push(.entryPoint))
    }
}

extension AppManager {
    private static func buildApiClient(apiClient: ApiClientProtocol? = nil) -> ApiClientProtocol {
        if let apiClient = apiClient {
            return apiClient
        }

        let apiKey = "2696829a81b1b5827d515ff121700838"
        let httpLayerBaseURL = "http://api.themoviedb.org"
        let version = 3
        let imageLayerBaseUrl = "http://image.tmdb.org"

        do {
            let httpLayer = try HttpLayer(apiKey: apiKey, baseUrl: httpLayerBaseURL, version: version)
            let imageHttpLayer = try ImageHttpLayer(baseUrl: imageLayerBaseUrl)
            return APIClient(httpLayer: httpLayer, imageHttpLayer: imageHttpLayer, decoder: DecoderBuilder.decoder)
        } catch let error {
            fatalError("Unable to create the HttpLayers \(error.localizedDescription)")
        }
    }

    private static func buildStoreClient(storeClient: SuggestionsProtocol? = nil) -> SuggestionsProtocol {
        if let storeClient = storeClient {
            return storeClient
        }
        return StoreClient(store: ExtremelyAdvancedStorageSystem.standard)
    }

    private static func buildPresenterManager(presenterManager: PresenterManagerProtocol? = nil, routingManager: RoutingManagerProtocol) -> PresenterManagerProtocol {
        if let presenterManager = presenterManager {
            return presenterManager
        }
        return PresenterManager(routingManager: routingManager)
    }

    private static func buildRoutingManager(routingManager: RoutingManagerProtocol? = nil,
                                            searchClient: SearchProtocol,
                                            suggestionsClient: SuggestionsProtocol,
                                            imageClient: ImageProtocol) -> RoutingManagerProtocol {
        if let routingManager = routingManager {
            return routingManager
        }
        return RoutingManager(searchClient: searchClient, suggestionsProtocol: suggestionsClient, imageClient: imageClient)
    }
}
