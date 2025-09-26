//
//  HomeView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI
import Observation

struct HomeView: View {
    @EnvironmentObject var router: Router
    @Bindable var viewModel: HomeViewModel

    @State var showStatusBar = true
    @State var contentHasScrolled = false
    @State var showNav = false
    @State var showDetail: Bool = false
    @State var selectedCharacter: CharacterBusinessModel?

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()

            scrollView

            // Network status indicator as overlay from bottom
            VStack {
                Spacer()
                NetworkStatusIndicator()
            }
        }
        .onChange(of: showDetail, {
            withAnimation {
                showNav.toggle()
                showStatusBar.toggle()
            }
        })
        .overlay(NavigationBarView(title: "Characters",
                                   contentHasScrolled: $contentHasScrolled))
        .statusBar(hidden: !showStatusBar)
        .onAppear {
            Task {
                await viewModel.ensureInitialLoad()
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Important message"),
                  message: Text(viewModel.viewError?.localizedDescription ?? "Unexpected error has happened"),
                  dismissButton: .default(Text("Got it!")))
        }.sheet(isPresented: $showDetail) {
            CharacterDetailView(character: selectedCharacter)
        }
    }
}
