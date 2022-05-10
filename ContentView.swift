//
//  ContentView.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            LoadingView()
        }
        .background(Color(hue: 0.618, saturation: 0.618, brightness: 0.618))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
