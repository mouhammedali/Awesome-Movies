//
//  Awesome_MoviesTests.swift
//  Awesome MoviesTests
//
//  Created by Mouhammed Ali on 6/27/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import XCTest
@testable import Awesome_Movies

class Awesome_MoviesTests: XCTestCase {
    var sut: ViewController!
    override func setUp() {
        super.setUp()
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:Bundle(for: type(of: self)))
        sut = ViewController()
        testParseJson()
        
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    func testFlickrCall(){
        FlickrApiHelper(title: "movie").getImages { (responceCode) in
             XCTAssert(200 == responceCode ?? 0, "statusCode is not matching the server data")
        }
    }
    func testParseJson() {
        sut.parseJson(fileName: "movies test")
        if let path = Bundle.main.path(forResource: "movies test", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let returnedData = try JSONDecoder().decode(MovieModel.self, from: data)
                let movies = returnedData.movies ?? [MovieModelItem]()
               XCTAssertEqual(movies.count, sut.dataArray.count)
            } catch {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }else{
             XCTFail("Error: file not found")
        }

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        sut.parseJson(fileName: "movies")
        self.measure {
            sut.searchWithTerm(text:"err")
            
        }
    }
    
}
