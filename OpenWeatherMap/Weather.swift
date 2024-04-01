//
//  Weather.swift
//  OpenWeatherMap
//
//  Created by Ляхевич Александр Олегович on 01.04.2024.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?

    var description: String {
        terms?["description"]?.first ?? "No further information"
    }

    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}

struct Weather: Codable {
    struct Coordinate: Codable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherDescription: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainInfo: Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Int
        var humidity: Int
        var sea_level: Int
        var grnd_level: Int
    }
    
    struct Wind: Codable {
        var speed: Double
        var deg: Int
        var gust: Double
    }
    
    struct Clouds: Codable {
        var all: Int
    }
    
    struct SysInfo: Codable {
        var type: Int
        var id: Int
        var country: String
        var sunrise: Int
        var sunset: Int
    }
    
    var coord: Coordinate
    var weather: [WeatherDescription]
    var base: String
    var main: MainInfo
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: Int
    var sys: SysInfo
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
    
    init() {
        self.coord = Coordinate(lon: 0.0, lat: 0.0)
        self.weather = []
        self.base = ""
        self.main = MainInfo(temp: 0.0, feels_like: 0.0, temp_min: 0.0, temp_max: 0.0, pressure: 0, humidity: 0, sea_level: 0, grnd_level: 0)
        self.visibility = 0
        self.wind = Wind(speed: 0.0, deg: 0, gust: 0.0)
        self.clouds = Clouds(all: 0)
        self.dt = 0
        self.sys = SysInfo(type: 0, id: 0, country: "", sunrise: 0, sunset: 0)
        self.timezone = 0
        self.id = 0
        self.name = ""
        self.cod = 0
    }
}
