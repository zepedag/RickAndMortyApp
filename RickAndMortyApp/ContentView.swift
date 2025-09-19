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
    
    var body: some View {
        NavigationStack(path: $router.navStack) {
            HomeView(viewModel: homeViewModel)
                .environmentObject(model)
                .environmentObject(router)
                .pushPath()
        }
    }
}

#Preview {
    ContentView()
}
