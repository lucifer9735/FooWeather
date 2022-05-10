//
//  ModelData.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/8.
//

import Foundation

var previewCity: ResponseCity = load("cityData.json")
var previewCurrentWeather: ResponseCurrentWeather = load("currentweatherData.json")
var previewCurrentAir: ResponseCurrentAir = load("currentairData.json")
var previewRecent7d: ResponseRecent7d = load("recent7dData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
