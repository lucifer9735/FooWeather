//
//  WeatherView.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/8.
//

import SwiftUI
import CoreLocationUI

struct WeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.refresh) private var refresh
    
    var city: ResponseCity
    var current: ResponseCurrentWeather
    var air: ResponseCurrentAir
    var recent: ResponseRecent7d
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(city.location[0].name) - \(city.location[0].adm2)")
                            .font(.title)
                        
                        Text(" \(current.updateTime.components(separatedBy: "+")[0].toDate().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    LocationButton {
                        
                        locationManager.requestLocation()
                        print(locationManager.isLoading)
                        
                    }
                    .labelStyle(.iconOnly)
                    .cornerRadius(30)
                    .symbolVariant(.fill)
                    .foregroundColor(.white)
                    
                    Button {
                        print("test")
                        Task {
                            await refresh?()
                        }
                    }label: {
                        Image("Foo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }.disabled(refresh == nil)
                }
                .padding()
                
                Spacer()
                
                HStack {
                    
                    WeatherIcon(Icon: current.now.icon, value: current.now.text)
                        .frame(maxWidth:150, alignment: .leading)
                        .foregroundColor(.white)

                    Spacer()

                    Text(current.now.temp + "°")
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
                
                Spacer()

                VStack(alignment: .leading, spacing: 0) {
                    Text("当前参数")
                        .bold()
                        .padding(.bottom)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            WeatherRow(logo: "thermometer", name: "体感温度", value: (current.now.feelsLike + ("°")))
                            Spacer()
                            WeatherRow(logo: "wind", name: "风速", value: (current.now.windSpeed + " m/s"))
                        }
                            
                        Spacer()

                        VStack(alignment: .leading) {
                            WeatherRow(logo: "aqi.medium", name: "PM2.5", value: (air.now.pm2p5))
                                Spacer()
                            WeatherRow(logo: "humidity", name: "相对湿度", value: (current.now.humidity + "%"))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 160, alignment: .leading)
                .padding()
                .padding(.bottom, 10)
                .foregroundColor(Color(hue: 0.618, saturation: 0.618, brightness: 0.618))
                .background(.white)
                .cornerRadius(20)
                
                Spacer()
                
                VStack {

                    VStack(alignment: .leading, spacing: 0) {
                        Text("近期温度")
                            .bold()
                            .padding(.bottom)
                        
                        Spacer()

                        VStack(alignment: .center, spacing: 0) {
                            LineGraph(dataHigh: recent.getTempMax(), dataLow: recent.getTempMin())
                                .frame(width: 320, height: 200)
                                .padding(.top, 20)
                        
                            HStack {
                                ForEach(recent.getDates(), id: \.self) { date in
                                    Text(date.components(separatedBy: "-")[2])
                                        .bold()
                                }
                                .frame(width: 40)
                            }
                            
                            Spacer()
                            
                            HStack {
                                ForEach(recent.getIcon(), id: \.self) { icon in
                                    Image(icon)
                                }
                                .frame(width: 40)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 10)
                    .foregroundColor(Color(hue: 0.618, saturation: 0.618, brightness: 0.618))
                    .background(Color("BG"))
                    .cornerRadius(20)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.618, saturation: 0.618, brightness: 0.618))
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(city: previewCity, current: previewCurrentWeather, air: previewCurrentAir, recent: previewRecent7d)
    }
}
