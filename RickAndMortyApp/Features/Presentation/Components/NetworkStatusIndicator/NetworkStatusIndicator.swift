//
//  NetworkStatusIndicator.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import SwiftUI

/// Component to display network connectivity status
struct NetworkStatusIndicator: View {
    @State private var networkMonitor = NetworkMonitor.shared
    @State private var showBanner = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !networkMonitor.isConnected {
                offlineBanner
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showBanner)
            }
        }
        .onAppear {
            showBanner = !networkMonitor.isConnected
        }
        .onChange(of: networkMonitor.isConnected) { _, isConnected in
            withAnimation(.easeInOut(duration: 0.3)) {
                showBanner = !isConnected
            }
        }
    }
    
    private var offlineBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            Text("No Internet Connection")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Spacer()
            
            Text("Using cached data")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                colors: [.red, .red.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .shadow(color: .red.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

/// Compact network status indicator for navigation bars
struct CompactNetworkStatusIndicator: View {
    @State private var networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: networkMonitor.isConnected ? networkMonitor.connectionTypeIcon : "wifi.slash")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(networkMonitor.isConnected ? .green : .red)
            
            if !networkMonitor.isConnected {
                Text("Offline")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 8)
    }
}

#Preview {
    VStack(spacing: 20) {
        NetworkStatusIndicator()
        
        CompactNetworkStatusIndicator()
        
        Spacer()
    }
    .background(Color("Background"))
}
