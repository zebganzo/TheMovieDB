//
//  SearchParserTests.swift
//  TheMovieDBTests
//
//  Created by Sebastiano Catellani on 11.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Quick
import Nimble

class SearchParserTests: QuickSpec {
    override func spec() {

        describe("Movie Search") {

            let testBundle = Bundle(for: type(of: self))

            context("parser") {

                it("Read from file") {
                    let url = testBundle.url(forResource: "BatmanSearch", withExtension: "json")
                    let jsonData = try! Data(contentsOf: url!)

                    let json = try! JSONSerialization.jsonObject(with: jsonData) as! JSON
                    let searchResult = try! SearchResult<Movie>(json: json)

                    expect(searchResult.page) == 1
                    expect(searchResult.totalResults) == 103
                    expect(searchResult.totalPages) == 6
                    expect(searchResult.results.first!.​name) == "Batman"
                    expect(searchResult.results.first!.posterPath) == "/kBf3g9crrADGMc2AMAMlLBgSm2h.jpg"
                    expect(searchResult.results.first!.releaseDate) == "1989-06-23"
                    expect(searchResult.results.first!.overview) == "The Dark Knight of Gotham City begins his war on crime with his first major enemy being the clownishly homicidal Joker, who has seized control of Gotham's underworld."
                }
            }
        }
    }
}
