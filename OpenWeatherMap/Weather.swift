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

struct CurrentUnits: Codable {
    var time: String = ""
    var interval: String = ""
    var temperature_2m: String = ""
    var relative_humidity_2m: String = ""
    var apparent_temperature: String = ""
    var is_day: String = ""
    var precipitation: String = ""
    var rain: String = ""
    var showers: String = ""
    var snowfall: String = ""
    var weather_code: String = ""
    var cloud_cover: String = ""
    var pressure_msl: String = ""
    var surface_pressure: String = ""
    var wind_speed_10m: String = ""
    var wind_direction_10m: String = ""
    var wind_gusts_10m: String = ""
    
    init() {}
}

struct Current: Codable {
    var time: String = ""
    var interval: Int = 0
    var temperature_2m: Double = 0.0
    var relative_humidity_2m: Int = 0
    var apparent_temperature: Double = 0.0
    var is_day: Int = 0
    var precipitation: Double = 0.0
    var rain: Double = 0.0
    var showers: Double = 0.0
    var snowfall: Double = 0.0
    var weather_code: Int = 0
    var cloud_cover: Int = 0
    var pressure_msl: Double = 0.0
    var surface_pressure: Double = 0.0
    var wind_speed_10m: Double = 0.0
    var wind_direction_10m: Int = 0
    var wind_gusts_10m: Double = 0.0
    
    init() {}
}

struct WeatherData: Codable {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var generationtime_ms: Double = 0.0
    var utc_offset_seconds: Int = 0
    var timezone: String = ""
    var timezone_abbreviation: String = ""
    var elevation: Double = 0.0
    var current_units: CurrentUnits = CurrentUnits()
    var current: Current = Current()
    
    init() {}
}

//struct Weather: Codable {
//    struct Coordinate: Codable {
//        var lon: Double
//        var lat: Double
//    }
//    
//    struct WeatherDescription: Codable {
//        var id: Int
//        var main: String
//        var description: String
//        var icon: String
//    }
//    
//    struct MainInfo: Codable {
//        var temp: Double
//        var feels_like: Double
//        var temp_min: Double
//        var temp_max: Double
//        var pressure: Int
//        var humidity: Int
//        var sea_level: Int
//        var grnd_level: Int
//    }
//    
//    struct Wind: Codable {
//        var speed: Double
//        var deg: Int
//        var gust: Double
//    }
//    
//    struct Clouds: Codable {
//        var all: Int
//    }
//    
//    struct SysInfo: Codable {
//        var type: Int
//        var id: Int
//        var country: String
//        var sunrise: Int
//        var sunset: Int
//    }
//    
//    var coord: Coordinate
//    var weather: [WeatherDescription]
//    var base: String
//    var main: MainInfo
//    var visibility: Int
//    var wind: Wind
//    var clouds: Clouds
//    var dt: Int
//    var sys: SysInfo
//    var timezone: Int
//    var id: Int
//    var name: String
//    var cod: Int
//    
//    init() {
//        self.coord = Coordinate(lon: 0.0, lat: 0.0)
//        self.weather = []
//        self.base = ""
//        self.main = MainInfo(temp: 0.0, feels_like: 0.0, temp_min: 0.0, temp_max: 0.0, pressure: 0, humidity: 0, sea_level: 0, grnd_level: 0)
//        self.visibility = 0
//        self.wind = Wind(speed: 0.0, deg: 0, gust: 0.0)
//        self.clouds = Clouds(all: 0)
//        self.dt = 0
//        self.sys = SysInfo(type: 0, id: 0, country: "", sunrise: 0, sunset: 0)
//        self.timezone = 0
//        self.id = 0
//        self.name = ""
//        self.cod = 0
//    }
//}
