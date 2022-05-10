//
//  WeatherManager.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/8.
//

import Foundation
import CoreLocation

let API_KEY = "API_KEY"

class WeatherManager {
    
    func getCurrentCity(longitude: CLLocationDegrees, latitude: CLLocationDegrees) async throws -> ResponseCity {
        guard let url = URL(string: "https://geoapi.qweather.com/v2/city/lookup?location=\(longitude.roundDouble2()),\(latitude.roundDouble2())&key=\(API_KEY)")
            else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        
        let decodedData = try JSONDecoder().decode(ResponseCity.self, from: data)
        
        return decodedData
    }
    
    func getCurrentWeather(longitude: CLLocationDegrees, latitude: CLLocationDegrees) async throws -> ResponseCurrentWeather {
        guard let url = URL(string: "https://devapi.qweather.com/v7/weather/now?location=\(longitude.roundDouble2()),\(latitude.roundDouble2())&key=\(API_KEY)")
            else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching current weather data") }
        
        let decodedData = try JSONDecoder().decode(ResponseCurrentWeather.self, from: data)
        
        return decodedData
    }
    
    func getCurrentAir(longitude: CLLocationDegrees, latitude: CLLocationDegrees) async throws -> ResponseCurrentAir {
        guard let url = URL(string: "https://devapi.qweather.com/v7/air/now?location=\(longitude.roundDouble2()),\(latitude.roundDouble2())&key=\(API_KEY)")
            else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching current weather data") }
        
        let decodedData = try JSONDecoder().decode(ResponseCurrentAir.self, from: data)
        
        return decodedData
    }
    
    func getRecent7d(longitude: CLLocationDegrees, latitude: CLLocationDegrees) async throws -> ResponseRecent7d {
        guard let url = URL(string: "https://devapi.qweather.com/v7/weather/7d?location=\(longitude.roundDouble2()),\(latitude.roundDouble2())&key=\(API_KEY)")
            else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching current weather data") }
        
        let decodedData = try JSONDecoder().decode(ResponseRecent7d.self, from: data)
        
        return decodedData
    }
}

struct ResponseCity: Decodable {
    var location: [LocationResponse]

    struct LocationResponse: Decodable {
        var name: String
        var adm1: String
        var adm2: String
    }
}

struct ResponseCurrentWeather: Decodable {
    var updateTime: String
    var now: CurrentWeatherResponse

    struct CurrentWeatherResponse: Decodable {
        var obsTime: String
        var temp: String
        var feelsLike: String
        var icon: String
        var text: String
        var wind360: String
        var windDir: String
        var windScale: String
        var windSpeed: String
        var humidity: String
        var precip: String
        var pressure: String
        var vis: String
    }
}

struct ResponseCurrentAir: Decodable {
    var updateTime: String
    var now: CurrentAirResponse

    struct CurrentAirResponse: Decodable {
        var pubTime: String
        var aqi: String
        var level: String
        var category: String
        var primary: String
        var pm10: String
        var pm2p5: String
        var no2: String
        var so2: String
        var co: String
        var o3: String
    }
}

struct ResponseRecent7d: Decodable {
    var updateTime: String
    var daily: [DailyResponse]

    struct DailyResponse: Decodable {
        var fxDate: String
        var tempMax: String
        var tempMin: String
        var iconDay: String
        var textDay: String
        var iconNight: String
        var textNight: String
    }
}
