//
//  LoadingView.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/8.
//

import SwiftUI
import CoreLocation

struct LoadingView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var city: ResponseCity?
    @State var current: ResponseCurrentWeather?
    @State var air: ResponseCurrentAir?
    @State var recent: ResponseRecent7d?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
//                Text("Your coordinates are:\(location.longitude),\(location.latitude)")
                if let city = city {
                    if let current = current {
                        if let air = air {
                            if let recent = recent {
                                WeatherView(city: city, current: current, air: air, recent: recent)
                                    .environmentObject(locationManager)
                                    .refreshable{
                                        print("refresh")
                                    }
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint:.white))
                                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                                    .task {
                                        do {
                                            recent = try await weatherManager.getRecent7d(longitude: location.longitude, latitude: location.latitude)
                                        } catch {
                                            print("Error getting recent weather: \(error)")
                                        }
                                    }
                            }

                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint:.white))
                                .frame(maxWidth:.infinity, maxHeight: .infinity)
                                .task {
                                    do {
                                        air = try await weatherManager.getCurrentAir(longitude: location.longitude, latitude: location.latitude)
                                    } catch {
                                        print("Error getting current air: \(error)")
                                    }
                                }
                        }

                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint:.white))
                            .frame(maxWidth:.infinity, maxHeight: .infinity)
                            .task {
                                do {
                                    current = try await weatherManager.getCurrentWeather(longitude: location.longitude, latitude: location.latitude)
                                } catch {
                                    print("Error getting current weather: \(error)")
                                }
                            }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:.white))
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                        .task {
                            do {
                                city = try await weatherManager.getCurrentCity(longitude: location.longitude, latitude: location.latitude)
                            } catch {
                                print("Error getting city: \(error)")
                            }
                        }
                }
                
            } else {
                if locationManager.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:.white))
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                } else {
                    WeatherView(city: previewCity, current: previewCurrentWeather, air: previewCurrentAir, recent: previewRecent7d)
                        .environmentObject(locationManager)
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
