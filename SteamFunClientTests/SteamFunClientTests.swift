//
//  SteamFunClientTests.swift
//  SteamFunClientTests
//
//  Created by Evgeny Kireev on 08.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import XCTest
@testable import SteamFunClient

class SteamFunClientTests: XCTestCase {
    
    struct Response<T: Decodable>: Decodable {
        let result: T
    }
    
    func testMatchDetailsDecoding() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "matchDetailsTestResponse", withExtension: "json") else {
            XCTFail("Missing file: matchDetailsTestResponse.json")
            return
        }
        let json: Data
        do {
            json = try Data(contentsOf: url)
        } catch {
            XCTFail("matchDetailsTestResponse.json data corrupted. Unable to convert to Data object")
            return
        }
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(Response<MatchDetails>.self, from: json)
        } catch {
            XCTFail("Decoding json data to Response<MatchDetails> failed. Error: \(error)")
        }
    }
}
