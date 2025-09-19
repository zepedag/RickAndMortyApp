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
    @State var selectedStatus: StatusBusinessModel? = nil
    @State var selectedSpecies: String? = nil
    @State var showStatusFilter = false
    @State var showSpeciesFilter = false
    @State var hasActiveFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Main content area - takes up available space
                VStack(spacing: 0) {
                    if viewModel.filteredCharacterList.isEmpty && !viewModel.characterList.isEmpty {
                        emptyView
                    } else if viewModel.characterList.isEmpty {
                        emptyView
                    } else {
                        searchView
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Filter Bar - always at bottom with smooth animation
                filterBar
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                    .animation(.easeInOut(duration: 0.3), value: hasActiveFilters)
            }
        }
        .searchable(text: $text)
        .onChange(of: text, { _, newValue in
            searchCharacter(by: newValue)
        })
        .onChange(of: selectedStatus, { _, _ in
            updateFilterState()
        })
        .onChange(of: selectedSpecies, { _, _ in
            updateFilterState()
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
    
    private func applyFilters() {
        viewModel.applyFilters(status: selectedStatus, species: selectedSpecies)
    }
    
    private func updateFilterState() {
        hasActiveFilters = selectedStatus != nil || selectedSpecies != nil
    }
    
    private func clearAllFilters() {
        selectedStatus = nil
        selectedSpecies = nil
        hasActiveFilters = false
        viewModel.clearFilters()
    }
    
    private var filterBar: some View {
        HStack(alignment: .top, spacing: 12) {
            // Filter Selection Buttons - More space now
            HStack(spacing: 12) {
                // Status Filter
                Button(action: {
                    showStatusFilter.toggle()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "circle.fill")
                            .foregroundColor(statusColor)
                            .font(.caption)
                        Text(selectedStatus?.rawValue.capitalized ?? "All Status")
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                .buttonStyle(.plain)
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
                .animation(.easeInOut(duration: 0.2).delay(0.1), value: hasActiveFilters)
                .confirmationDialog("Filter by Status", isPresented: $showStatusFilter) {
                    Button("All Status") {
                        selectedStatus = nil
                    }
                    Button("Alive") {
                        selectedStatus = .alive
                    }
                    Button("Dead") {
                        selectedStatus = .dead
                    }
                    Button("Unknown") {
                        selectedStatus = .unknown
                    }
                    Button("Cancel", role: .cancel) { }
                }
                
                // Species Filter
                Button(action: {
                    showSpeciesFilter.toggle()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        Text(selectedSpecies ?? "All Species")
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                .buttonStyle(.plain)
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
                .animation(.easeInOut(duration: 0.2).delay(0.2), value: hasActiveFilters)
                .confirmationDialog("Filter by Species", isPresented: $showSpeciesFilter) {
                    Button("All Species") {
                        selectedSpecies = nil
                    }
                    Button("Human") {
                        selectedSpecies = "Human"
                    }
                    Button("Alien") {
                        selectedSpecies = "Alien"
                    }
                    Button("Humanoid") {
                        selectedSpecies = "Humanoid"
                    }
                    Button("Robot") {
                        selectedSpecies = "Robot"
                    }
                    Button("Animal") {
                        selectedSpecies = "Animal"
                    }
                    Button("Mythological Creature") {
                        selectedSpecies = "Mythological Creature"
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
            
            Spacer()
            
            // Action Buttons - Vertical Stack
            if hasActiveFilters {
                VStack(spacing: 6) {
                    // Apply Filters Button
                    Button(action: {
                        applyFilters()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                            Text("Aplicar")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                    .animation(.easeInOut(duration: 0.2).delay(0.3), value: hasActiveFilters)
                    
                    // Clear Filters Button
                    Button(action: {
                        clearAllFilters()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                            Text("Limpiar")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                    .animation(.easeInOut(duration: 0.2).delay(0.4), value: hasActiveFilters)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var statusColor: Color {
        switch selectedStatus {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .orange
        case .none:
            return .gray
        }
    }
}
