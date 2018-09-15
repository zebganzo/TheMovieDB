//
//  SearchHeaderView.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 15.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result
import UIKit

class SearchHeaderView: UITableViewHeaderFooterView {

    private let searchTextField = UITextField()
    private let searchButton = UIButton()

    var searchTextSignal: Signal<String, NoError> {
        return self.searchButton.reactive.controlEvents(.touchUpInside)
            .map { [unowned self] _ -> String? in self.searchTextField.text }
            .skipNil()
            .filter { !$0.isEmpty }
    }

    init(loadingSignalProducer: SignalProducer<Bool, NoError>) {
        super.init(reuseIdentifier: nil)

        // Style

        self.searchTextField.backgroundColor = .white
        self.searchTextField.placeholder = "Search a movie..."
        self.searchTextField.setInternalPadding()

        self.searchButton.setBackgroundColor(color: .black, forState: .normal)
        self.searchButton.setBackgroundColor(color: .gray, forState: .disabled)
        self.searchButton.setTitleColor(.white, for: .normal)
        self.searchButton.setTitle("Search!", for: .normal)
        self.searchButton.isEnabled = false

        // Binding

        let searchTextFieldSignalProducer = self.searchTextField.reactive
            .continuousTextValues
            .map { text in !(text ?? "").isEmpty }
            .producer

        self.searchButton.reactive.isEnabled <~ SignalProducer
            .combineLatest(searchTextFieldSignalProducer, loadingSignalProducer)
            .map { (searchTextFieldNotEmpty, isLoading) in
                return searchTextFieldNotEmpty && !isLoading
        }

        // Constraints

        self.addSubview(self.searchTextField)
        self.addSubview(self.searchButton)

        self.searchTextField.snp.makeConstraints { make -> Void in
            make.width.equalTo(self)
            make.height.equalTo(self).dividedBy(2)
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }

        self.searchButton.snp.makeConstraints { make -> Void in
            make.width.equalTo(self)
            make.height.equalTo(self).dividedBy(2)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
