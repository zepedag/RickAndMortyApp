//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 17/09/25.
//

import SwiftUI

@main
struct RickAndMortyAppApp: App {
    @StateObject var router = Router()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navStack) {
                ContentView()
            }.environmentObject(router)

        }
    }
}
