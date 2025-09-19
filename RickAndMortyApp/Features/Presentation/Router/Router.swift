//
//  Router.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI
import Combine

protocol RouterDelegate {
    associatedtype Route = Path
    func pushView(_ newView : Route)
    func poptoRoot()
    func pop()
    func popUntil(_ targetRoute : Route)
}

extension Router {
    enum Paths: Equatable, CaseIterable {
        static var allCases: [Router.Paths] = [.homePage, .favorites]
        case homePage
        case favorites
        case custom(view: AnyView)
    }

    enum Routes {
        static let routes: [Paths: AnyView] = [
            .homePage: AnyView(HomeView(viewModel: HomeViewModel())),
            .favorites: AnyView(FavoritesView(viewModel: FavoritesViewModel())),
       ]
    }
    
    static func getRoute(for path: Paths) -> AnyView {
        switch path {
            case .homePage:
                return AnyView(HomeView(viewModel: HomeViewModel()))
            case .favorites:
                return AnyView(FavoritesView(viewModel: FavoritesViewModel()))
            case .custom(let view):
                return view
        }
    }
}

class Router: ObservableObject, RouterDelegate {
    @Environment(\.presentationMode) var presentationMode
    
    @Published var navStack: [Paths] = []
 
    func pushView(_ newView: Paths) {
        navStack.append(newView)
    }
            
    func poptoRoot() {
        navStack.removeAll()
    }
    
    func pop() {
        if !navStack.isEmpty {
            navStack.removeLast()
        }
    }
    
    func popUntil(_ targetRoute: Paths) {
        if !navStack.isEmpty {
            navStack.removeLast()
        }
    }
}

extension View {
    func pushPath() -> some View {
        self.navigationDestination(for: Router.Paths.self) { path in
            Router.getRoute(for: path)
        }
    }
}

extension Router.Paths: Hashable {
    static func == (lhs: Router.Paths, rhs: Router.Paths) -> Bool {
        switch (lhs, rhs) {
            case (.homePage, .homePage):
                return true
            case (.favorites, .favorites):
                return true
            case (.custom, .custom):
                return true
            default:
                return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
            case .homePage:
                hasher.combine("homePage")
            case .favorites:
                hasher.combine("favorites")
            case .custom(_):
                hasher.combine("custom")
        }
    }
}


