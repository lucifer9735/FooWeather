//
//  LineGraph.swift
//  FooWeather
//
//  Created by Foo's MBP on 2022/5/8.
//

import SwiftUI

struct LineGraph: View {
    var dataHigh: [CGFloat]
    var dataLow: [CGFloat]
    
    @State var maxTempPlot = ""
    @State var minTempPlot = ""
    @State var offsetHigh: CGSize = .zero
    @State var offsetLow: CGSize = .zero
    @State var showPlot = false
    @State var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / (CGFloat(dataHigh.count) - 1)
            
            let maxPoint = (dataHigh.max() ?? 0) + 1
            
            let pointsHigh = dataHigh.enumerated().compactMap { item -> CGPoint in
                
                let progress = item.element / maxPoint
            
                let pathHeight = progress * height
                
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            let pointsLow = dataLow.enumerated().compactMap { item -> CGPoint in
                
                let progress = item.element / maxPoint
            
                let pathHeight = progress * height
                
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                
                // Path...
                Path { path in
                    
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(pointsHigh)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [
                        Color("Gradient1"),
                        Color("Gradient2"),
                    ],startPoint: .leading, endPoint: .trailing)
                )
                
                LinearGradient(colors: [
                    Color("Gradient2")
                        .opacity(0.3),
                    Color("Gradient2")
                        .opacity(0.2),
                    Color("Gradient2")
                        .opacity(0.1)]
                    + Array(repeating:
                        Color("Gradient1")
                        .opacity(0.1), count: 4)
                    + Array(repeating:
                        Color.clear, count: 2)
                    , startPoint: .top, endPoint: .bottom)
                    // Clipping the shape...
                    .clipShape(
                        Path { path in

                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLines(pointsHigh)
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    )
                    .padding(.top, 7)
                
                Path { path in

                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(pointsLow)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [
                        Color("Gradient3"),
                        Color("Gradient4"),
                    ],startPoint: .leading, endPoint: .trailing)
                )

                LinearGradient(colors: [
                    Color("Gradient4")
                        .opacity(0.3),
                    Color("Gradient4")
                        .opacity(0.2),
                    Color("Gradient4")
                        .opacity(0.1)]
                    + Array(repeating:
                        Color("Gradient3")
                        .opacity(0.1), count: 4)
                    + Array(repeating:
                        Color.clear, count: 2)
                    , startPoint: .top, endPoint: .bottom)
                    // Clipping the shape...
                    .clipShape(
                        Path { path in

                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLines(pointsLow)
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    )
                    .padding(.top, 7)
            }
            .overlay(
                    
                ZStack() {
                    
                    VStack(spacing: 0) {
                        
                        Text(maxTempPlot)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color("Gradient1"), in: Capsule())
                            .offset(x: translation < 10 ? 30 : 0)
                            .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                        
                        Rectangle()
                            .fill(Color("Gradient1"))
                            .frame(width: 1, height: 40)
                            .padding(.top)
                        
                        Circle()
                            .fill(Color("Gradient1"))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Circle()
                                    .fill(Color(.white))
                                    .frame(width: 10, height: 10)
                            )
                        
                        Rectangle()
                            .fill(Color("Gradient1"))
                            .frame(width: 1, height: 40)
                            .opacity(0)
                    }
                    .frame(width: 80, height: 180)
                    .offset(y: 70)
                    .offset(offsetHigh);
                    
                    Spacer(minLength: 40);
                    
                    VStack(spacing: 0) {
                        
                        Rectangle()
                            .fill(Color("Gradient3"))
                            .frame(width: 1, height: 100)
                            .padding(.top)
                            .opacity(0)
                        
                        Circle()
                            .fill(Color("Gradient3"))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Circle()
                                    .fill(Color(.white))
                                    .frame(width: 10, height: 10)
                            )
                        
                        Rectangle()
                            .fill(Color("Gradient3"))
                            .frame(width: 1, height: 30)
                            .padding(.bottom)
                        
                        Text(minTempPlot)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color("Gradient3"), in: Capsule())
                            .offset(x: translation < 10 ? 30 : 0)
                            .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    }
                    .frame(width: 80, height: 180)
                    .offset(y: 70)
                    .offset(offsetLow)

                    
                }
                .opacity(showPlot ? 1 : 0),
                    
                alignment: .bottomLeading
                 
            )
            .gesture(DragGesture().onChanged({ value in

                    withAnimation{showPlot = true}

                    let translation = value.location.x - 40

                    let  index = max(min(Int((translation / width).rounded() + 1), dataHigh.count - 1), 0)

                    maxTempPlot = dataHigh[index].roundFloat() + "°"
                    minTempPlot = dataLow[index].roundFloat() + "°"

                    self.translation = translation

                    offsetHigh = CGSize(width: pointsHigh[index].x - 40, height: pointsHigh[index].y - height)
                    offsetLow = CGSize(width: pointsLow[index].x - 40, height: pointsLow[index].y - height)

                }).onEnded({ value in

                    withAnimation{showPlot = false}

                }))
        }
        .padding(.horizontal, 10)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(city: previewCity, current: previewCurrentWeather, air: previewCurrentAir, recent: previewRecent7d)
    }
}
