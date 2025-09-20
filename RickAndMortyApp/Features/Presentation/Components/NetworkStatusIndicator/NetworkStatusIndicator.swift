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
        Group {
            if !networkMonitor.isConnected {
                offlineBanner
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            }
        }
        .onAppear {
            updateBannerVisibility()
            print("📱 NetworkStatusIndicator: Appeared, isConnected: \(networkMonitor.isConnected)")
        }
        .onChange(of: networkMonitor.isConnected) { _, isConnected in
            print("📱 NetworkStatusIndicator: Connection changed to: \(isConnected)")
            print("📱 NetworkStatusIndicator: Connection type: \(networkMonitor.connectionTypeDescription)")
            updateBannerVisibility()
        }
        .onChange(of: networkMonitor.connectionType) { _, connectionType in
            print("📱 NetworkStatusIndicator: Connection type changed to: \(connectionType)")
        }
    }
    
    private func updateBannerVisibility() {
        let shouldShowBanner = !networkMonitor.isConnected
        print("📱 NetworkStatusIndicator: Updating banner visibility to: \(shouldShowBanner)")
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showBanner = shouldShowBanner
        }
    }
    
    private var offlineBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("No Internet Connection")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text("Check your network settings")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "wifi.slash")
                .font(.system(size: 16, weight: .medium))
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
                .animation(.easeInOut(duration: 0.2), value: networkMonitor.isConnected)
            
            if !networkMonitor.isConnected {
                Text("Offline")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 8)
        .animation(.easeInOut(duration: 0.2), value: networkMonitor.isConnected)
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
