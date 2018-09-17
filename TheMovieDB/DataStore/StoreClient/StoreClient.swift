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
    private static let maximumCapacity = 10

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

        // Is the new suggestion already in the list?
        if let index = suggestions.value.index(of: suggestion) {
            // Move it at the head, if it's not already there
            if index > 0 {
                suggestions.value.insert(suggestions.value.remove(at: index), at: 0)
            }
            return
        }

        // Is it already full?
        if suggestions.value.count == StoreClient.maximumCapacity {
            // Discard the oldest
            suggestions.value.removeLast()
        }

        // Insert at the head
        suggestions.value.insert(suggestion, at: 0)
    }
}
