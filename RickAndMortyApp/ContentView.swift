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
    
    var body: some View {
        NavigationStack(path: $router.navStack) {
            HomeView(viewModel: HomeViewModel())
                .environmentObject(model)
                .environmentObject(router)
                .pushPath()
        }
    }
}

#Preview {
    ContentView()
}
