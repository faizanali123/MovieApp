//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Faizan Ali on 11/09/2023.
//

import XCTest
@testable import MovieApp

final class MovieAppTests: XCTestCase {

    //test for searching functionality
    func testMovieNamesSearch() {

        // Arrange
        let movieModels = ["The Matrix","Inception","Avatar","The Shawshank Redemption"]
        var movieNamesSearch = movieModels
           
           let searchString = "The" // Test with a search string
           
           // Act
        movieNamesSearch = searchString.isEmpty ? movieModels : movieModels.filter{ $0.contains(searchString)}
        
           // Assert
           XCTAssertEqual(movieNamesSearch.count, 2) // Check that there are 2 movies containing "The"
           XCTAssertTrue(movieNamesSearch.contains(where: { $0 == "The Matrix" }))
           XCTAssertTrue(movieNamesSearch.contains(where: { $0 == "The Shawshank Redemption" }))
       }
    
    //test for searching and find no results
    func testMovieNamesSearchWithNoMatches() {
           // Arrange
        let movieModels = ["The Matrix","Inception","Avatar","The Shawshank Redemption"]
        var movieNamesSearch = movieModels
           
           let searchString = "NonExistentMovie" // Test with a search string that won't match any movie
           
           // Act
        movieNamesSearch = searchString.isEmpty ? movieModels : movieModels.filter{ $0.contains(searchString)}
           
           // Assert
           XCTAssertEqual(movieNamesSearch.count, 0) // Expect no movies to be included
       }
    

}
