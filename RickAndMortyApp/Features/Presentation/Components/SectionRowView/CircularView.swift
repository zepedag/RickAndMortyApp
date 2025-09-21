//
//  CircularView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI

struct CircularView: View {
    var value: CGFloat = 0.5
    var lineWidth: Double = 4
    var status: StatusBusinessModel?

    @State var appear = false

    var body: some View {
        Circle()
            .trim(from: 0, to: appear ? 1.0 : 0)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .fill(statusColor)
            .rotationEffect(.degrees(270))
            .onAppear {
                withAnimation(.spring().delay(0.5)) {
                    appear = true
                }
            }
            .onDisappear {
                appear = false
            }
    }

    private var statusColor: Color {
        switch status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .orange
        case .none:
            return .gray
        }
    }
}
