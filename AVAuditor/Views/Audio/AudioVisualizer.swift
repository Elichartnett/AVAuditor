//
// AudioVisualizer.swift
// AudioVisualizer
//
// Created by Alex Barbulescu on 2019-04-06.
// Copyright © 2019 alex. All rights reserved.
//

import Accelerate
import AVKit
import Charts
import SwiftUI

struct AudioVisualizer: View {

    @ObservedObject var manager: AudioManager

    @State var data = [Float]()
    
    private let magnitudeMin: Float = 1
    private let magnitudeMax: Float = 5

    var body: some View {
        
        GeometryReader { proxy in
            
            Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
                let ratio = magnitude.magnitude / magnitudeMax
                let scaledRatio = ratio * Float(proxy.size.height)
                let minnedRatio = max(magnitudeMin, scaledRatio)
                let maxxedRatio = min(minnedRatio, Float(proxy.size.height))
                
                BarMark(
                    x: .value(Constants.frequency, String(index)),
                    y: .value(Constants.magnitude, maxxedRatio)
                )
                .foregroundStyle(.white)
            }
            .onChange(of: manager.fftMagnitudes) { _ in
                updateData()
            }
            .animation(.linear(duration: 0.1), value: data)
            .chartYScale(domain: 0...Float(proxy.size.height))
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
    }

    func updateData() {
        data = manager.fftMagnitudes.map { Float($0) }
    }
}
