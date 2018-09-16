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

                    let httpLayer: HttpLayerProtocol = try! HttpLayer(apiKey: apiKey, baseUrl: baseURL, version: version)
                    let url = httpLayer.buildUrl(endpoint: endpoint)

                    expect(url).toNot(beNil())
                    expect(url?.absoluteString) == expectedUrl
                }
            }
        }

        describe("Image Http Layer") {

            context("build URL") {

                let baseURL = "http://image.tmdb.org/t/p/"
                let imageName = "/2DtPSyODKWXluIRV7PVru0SSzja.jpg"

                it("for ​w92 size poster URL") {
                    let expectedUrl = "\(baseURL)w92\(imageName)"

                    let endpoint: Endpoint = .image(imageName, .​w92)

                    let httpLayer: HttpLayerProtocol = try! ImageHttpLayer(baseUrl: baseURL)
                    let url = httpLayer.buildUrl(endpoint: endpoint)

                    expect(url?.absoluteString) == expectedUrl
                }

                it("for ​w185 size poster URL") {
                    let expectedUrl = "\(baseURL)w185\(imageName)"

                    let endpoint: Endpoint = .image(imageName, .​w92)

                    let httpLayer: HttpLayerProtocol = try! ImageHttpLayer(baseUrl: baseURL)
                    let url = httpLayer.buildUrl(endpoint: endpoint)

                    expect(url?.absoluteString) == expectedUrl
                }

                it("for ​w500 size poster URL") {
                    let expectedUrl = "\(baseURL)w500\(imageName)"

                    let endpoint: Endpoint = .image(imageName, .​w92)

                    let httpLayer: HttpLayerProtocol = try! ImageHttpLayer(baseUrl: baseURL)
                    let url = httpLayer.buildUrl(endpoint: endpoint)

                    expect(url?.absoluteString) == expectedUrl
                }

                it("for ​w780 size poster URL") {
                    let expectedUrl = "\(baseURL)w780\(imageName)"

                    let endpoint: Endpoint = .image(imageName, .​w92)

                    let httpLayer: HttpLayerProtocol = try! ImageHttpLayer(baseUrl: baseURL)
                    let url = httpLayer.buildUrl(endpoint: endpoint)

                    expect(url?.absoluteString) == expectedUrl
                }
            }
        }
    }
}
