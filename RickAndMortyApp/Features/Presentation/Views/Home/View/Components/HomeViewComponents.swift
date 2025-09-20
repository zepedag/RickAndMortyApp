//
//  HomeViewComponents.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI

extension HomeView {
    var scrollView: some View {
        ScrollView() {
            scrollDetectionView
            characterListView
                .padding(.vertical, 70)
                .padding(.bottom, 50)
        }
        .coordinateSpace(.named("scroll"))
        .refreshable {
            await viewModel.refreshCharacterList()
        }
    }
    
    var scrollDetectionView: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                let estimatedContentHeight = CGFloat(viewModel.characterList.count * 100)
                let threshold = 0.8 * estimatedContentHeight
                if value <= -threshold {
                    Task {
                        await viewModel.loadCharacterList()
                    }
                }
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }

    var characterListView: some View {
        Group {
            if viewModel.characterList.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                VStack(spacing: 16) {
                    ForEach(Array(viewModel.characterList.enumerated()), id: \.offset) { index, businessModel in
                        SectionRowView(section: SectionRowModel(businessModel: businessModel))
                            .onTapGesture {
                                selectedCharacter = businessModel
                                showDetail = true
                            }
                        if index == viewModel.characterList.count - 1 {
                            Divider()
                            if viewModel.isLoading {
                                ProgressView("Loading more characters...")
                                    .accentColor(.white)
                            }
                        } else {
                            Divider()
                        }
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .backgroundStyle(cornerRadius: 30)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Characters Available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Unable to load characters at the moment")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                Task {
                    await viewModel.loadCharacterList()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                    Text("Try Again")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(.horizontal, 20)
    }
}

