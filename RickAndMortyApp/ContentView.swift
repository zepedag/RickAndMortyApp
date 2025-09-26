//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = NavigationBarModel()
    @StateObject var router = Router()
    @State var homeViewModel = HomeViewModel()
    @State private var networkMonitor = NetworkMonitor.shared

    var body: some View {
        NavigationStack(path: $router.navStack) {
            HomeView(viewModel: homeViewModel)
                .environmentObject(model)
                .environmentObject(router)
                .pushPath()
                .overlay(alignment: .topTrailing) {
                    // Botón temporal para demo (solo en modo debug)
                    #if DEBUG
                    demoModeButton
                    #endif
                }
        }
        .onAppear {
            // Network monitoring starts automatically
            print("ContentView: Network monitoring is automatic")
        }
    }
    
    // MARK: - 
    #if DEBUG
    private var demoModeButton: some View {
        Button(action: {
            networkMonitor.toggleDemoMode()
        }) {
            Image(systemName: networkMonitor.demoMode ? "wifi.slash" : "wifi")
                .foregroundColor(networkMonitor.demoMode ? .red : .green)
                .font(.title2)
                .padding(8)
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
        }
        .padding(.top, 50)
        .padding(.trailing, 20)
    }
    #endif
}

#Preview {
    ContentView()
}
