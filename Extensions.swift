//
//  Extensions.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/8.
//

import Foundation
import SwiftUI

extension Double {
    
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
    
    func roundDouble2() -> String {
        return String(format: "%.2f", self)
    }
}

extension CGFloat {
    
    func roundFloat() -> String {
        return String(format: "%.0f", self)
    }
}

extension String {
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date()
    }
}

extension ResponseRecent7d {
    
    func getDates() -> [String] {
        var data: [String] = []
        for index in 0...6 {
            data.append(self.daily[index].fxDate)
        }
        return data
    }
    
    func getIcon() -> [String] {
        var data: [String] = []
        for index in 0...6 {
            data.append(self.daily[index].iconDay)
        }
        return data
    }
    
    func getTempMax() -> [CGFloat] {
        var data: [CGFloat] = []
        for index in 0...6 {
            data.append((self.daily[index].tempMax as NSString).doubleValue)
        }
        return data
    }
    
    func getTempMin() -> [CGFloat] {
        var data: [CGFloat] = []
        for index in 0...6 {
            data.append((self.daily[index].tempMin as NSString).doubleValue)
        }
        return data
    }
}
