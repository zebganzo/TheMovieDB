//
//  AppManager.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 16.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

enum AppManagerError: Error {
    case initialization(Error)
}

/// The `AppManager` is in charge of the creation of the main components necessary for the app to work:
/// - `apiClient`: for backend integration
/// - `storeClient`: local storage for the suggestions
/// - `presenterManager`: component in charge of presenting the views
/// - `routingManager`: component in charge of making the routing decisions
class AppManager {

    let apiClient: ApiClientProtocol
    let storeClient: SuggestionsProtocol
    let presenterManager: PresenterManagerProtocol
    let routingManager: RoutingManagerProtocol

    init(apiClient: ApiClientProtocol? = nil
        , storeClient: SuggestionsProtocol? = nil
        , presenterManager: PresenterManagerProtocol? = nil
        , routingManager: RoutingManagerProtocol? = nil) throws {
        self.apiClient = try type(of: self).buildApiClient(apiClient: apiClient)
        self.storeClient = type(of: self).buildStoreClient(storeClient: storeClient)
        self.routingManager =  type(of: self).buildRoutingManager(routingManager: routingManager, searchClient: self.apiClient, suggestionsClient: self.storeClient, imageClient: self.apiClient)
        self.presenterManager = type(of: self).buildPresenterManager(presenterManager: presenterManager, routingManager: self.routingManager)

        // Start the routing
        self.presenterManager.perform(action: PresenterManagerAction.push(.entryPoint))
    }
}

extension AppManager {

    /// If necessary, build an instance of that conforms to the `ApiClientProtocol`.
    private static func buildApiClient(apiClient: ApiClientProtocol? = nil) throws -> ApiClientProtocol {
        if let apiClient = apiClient {
            return apiClient
        }

        let apiKey = "2696829a81b1b5827d515ff121700838"
        let movieHttpLayerBaseURL = "http://api.themoviedb.org"
        let version = 3
        let imageHttpLayerBaseUrl = "http://image.tmdb.org"

        do {
            return ApiClient(movieHttpLayer: try MovieHttpLayer(apiKey: apiKey, baseUrl: movieHttpLayerBaseURL, version: version),
                             imageHttpLayer: try ImageHttpLayer(baseUrl: imageHttpLayerBaseUrl),
                             decoder: DecoderBuilder.decoder)
        } catch let error {
            throw AppManagerError.initialization(error)
        }
    }

    /// If necessary, build an instance of that conforms to the `SuggestionsProtocol`.
    private static func buildStoreClient(storeClient: SuggestionsProtocol? = nil) -> SuggestionsProtocol {
        if let storeClient = storeClient {
            return storeClient
        }
        return StoreClient(store: ExtremelyAdvancedStorageSystem.standard)
    }

    /// If necessary, build an instance of that conforms to the `PresenterManagerProtocol`.
    private static func buildPresenterManager(presenterManager: PresenterManagerProtocol? = nil, routingManager: RoutingManagerProtocol) -> PresenterManagerProtocol {
        if let presenterManager = presenterManager {
            return presenterManager
        }
        return PresenterManager(routingManager: routingManager)
    }

    /// If necessary, build an instance of that conforms to the `RoutingManagerProtocol`.
    /// The `RoutingManager` needs the clients for its initialisation.
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
