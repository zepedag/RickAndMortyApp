//
//  SearchView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI
import Observation
import Combine

struct SearchView: View {
    @Bindable var viewModel: SearchViewModel
    @State var text = ""
    @State var showCharacterDetail = false
    @State var selectedCharacter: CharacterBusinessModel?
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.characterList.isEmpty {
                    emptyView
                } else {
                    searchView
                }
                Spacer()
            }
        }
        .searchable(text: $text)
        .onChange(of: text, { _, newValue in
            searchCharacter(by: newValue)
        })
    }
}

extension SearchView {
    private func searchCharacter(by text: String) {
        viewModel.workItem?.cancel()
        let task = DispatchWorkItem { [weak viewModel] in
            guard let viewModel else { return }
            Task {
                await viewModel.searchCharacter(by: text, isFirstLoad: true)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        viewModel.workItem = task
    }
}
