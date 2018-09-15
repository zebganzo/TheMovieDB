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

protocol StoreProtocol {
    var suggestionsSignal: Signal<[Suggestion], NoError> { get }
    func save(suggestion: Suggestion)
}

typealias ExtremelyAdvancedStorageSystem = UserDefaults
typealias Suggestion = String

final class StoreClient: StoreProtocol {

    private let store: ExtremelyAdvancedStorageSystem
    private static let storageKey = "Suggestions"

    private var suggestions: MutableProperty<[Suggestion]>

    let suggestionsSignal: Signal<[Suggestion], NoError>
    private let suggestionsSink: Signal<[Suggestion], NoError>.Observer

    init(store: ExtremelyAdvancedStorageSystem) {
        self.store = store
        if let suggestions = self.store.object(forKey: StoreClient.storageKey) as? [Suggestion] {
            self.suggestions = MutableProperty(suggestions)
        } else {
            self.suggestions = MutableProperty([])
        }

        (self.suggestionsSignal, self.suggestionsSink) = Signal<[Suggestion], NoError>.pipe()
        self.suggestions.signal.observeValues { [unowned self] suggestions in
            self.suggestionsSink.send(value: suggestions)
        }
    }

    deinit {
        self.store.set(suggestions, forKey: StoreClient.storageKey)
    }

    func save(suggestion: Suggestion) {
        if !suggestions.value.contains(suggestion) {
            suggestions.value.append(suggestion)
        }
    }
}
