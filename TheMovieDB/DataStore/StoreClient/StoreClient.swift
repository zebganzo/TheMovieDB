//
//  StoreClient.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 15.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol SuggestionsProtocol {
    var suggestions: MutableProperty<[Suggestion]> { get }
    func save(suggestion: Suggestion)
}

typealias ExtremelyAdvancedStorageSystem = UserDefaults
typealias Suggestion = String

final class StoreClient: SuggestionsProtocol {

    private let store: ExtremelyAdvancedStorageSystem
    private static let storageKey = "Suggestions"

    var suggestions = MutableProperty<[Suggestion]>([])

    init(store: ExtremelyAdvancedStorageSystem) {
        self.store = store

        self.suggestions.signal.observeValues { [unowned self] suggestions in
            self.store.set(suggestions, forKey: StoreClient.storageKey)
        }

        if let suggestions = self.store.object(forKey: StoreClient.storageKey) as? [Suggestion] {
            self.suggestions.value = suggestions
        }
    }

    func save(suggestion: Suggestion) {
        if !suggestions.value.contains(suggestion) {
            suggestions.value.append(suggestion)
        }
    }
}
