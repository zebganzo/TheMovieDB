//
//  HttpLayerTests.swift
//  TheMovieDBTests
//
//  Created by Sebastiano Catellani on 10.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Quick
import Nimble

class HttpLayerTests: QuickSpec {
    override func spec() {

        describe("Authenticated Http Layer") {

            context("build URL") {

                it("for search endpoint") {
                    let expectedUrl = "http://api.themoviedb.org/3/search/movie?query=batman&page=1&api_key=2696829a81b1b5827d515ff121700838"

                    let apiKey = "2696829a81b1b5827d515ff121700838"
                    let baseURL = "http://api.themoviedb.org"
                    let version = 3
                    let endpoint: Endpoint = .search("batman", 1)

                    let httpLayer: HttpLayerProtocol = try! AuthenticatedHttpLayer(apiKey: apiKey, baseUrl: baseURL, version: version)
                    let url = httpLayer.buildUrl(endpoint: endpoint)

                    expect(url).toNot(beNil())
                    expect(url?.absoluteString) == expectedUrl
                }
            }
        }

        describe("Image Http Layer") {

            context("build URL") {

                it("for download an image data") {
                    let expectedUrl = "http://image.tmdb.org/t/p/w92/2DtPSyODKWXluIRV7PVru0SSzja.jpg"

                    let baseURL = "http://image.tmdb.org"
                    let imageName = "2DtPSyODKWXluIRV7PVru0SSzja.jpg"
                    let endpoint: Endpoint = .image(imageName, .​w92)

                    let httpLayer: HttpLayerProtocol = try! ImageHttpLayer(baseUrl: baseURL)
                    let url = httpLayer.buildUrl(endpoint: endpoint)

                    expect(url).toNot(beNil())
                    expect(url?.absoluteString) == expectedUrl
                }
            }
        }
    }
}
