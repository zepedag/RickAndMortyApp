//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = NavigationBarModel()
    
    var body: some View {
        HomeView(viewModel: HomeViewModel())
            .environmentObject(model)
    }
}

#Preview {
    ContentView()
}
