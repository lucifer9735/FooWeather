//
//  WeatherIcon.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/9.
//

import SwiftUI

struct WeatherIcon: View {
    var Icon: String
    var value: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(Icon)
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color("BG"))
                .cornerRadius(50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("当前天气")
                    .font(.caption)
                
                Text(value)
                    .bold()
                    .font(.title)
            }
        }
    }
}

struct WeatherIcon_Previews: PreviewProvider {
    static var previews: some View {
        WeatherIcon(Icon: "100", value: "晴朗")
    }
}
