//
//  URLManager.swift
//  MoviePractice
//
//  Created by EthanLin on 2018/6/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import Foundation

struct URLManager {
    static let apiKey = "a1f658d003fcc89fa99f1aac3d502623"
    static let getGuestSessionIDURL = "https://api.themoviedb.org/3/authentication/guest_session/new"
    static let fetchNowPlayingMovies = "https://api.themoviedb.org/3/movie/now_playing"
    static let fetchPopularMovies = "https://api.themoviedb.org/3/movie/popular"
    static let fetchTopRatedMovies = "https://api.themoviedb.org/3/movie/top_rated"
    static let fetchUpcomingMovies = "https://api.themoviedb.org/3/movie/upcoming"
    static let baseImageURL = "https://image.tmdb.org/t/p/h100/"
    static let postRatingURL = "https://api.themoviedb.org/3/movie/"
}
