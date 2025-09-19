//
//  SwiftUIView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//

import SwiftUI
import Combine

struct NavigationBarView: View {
    var title: String = ""
    
    @State var showSheet = false
    @Binding var contentHasScrolled: Bool
    @EnvironmentObject var model: NavigationBarModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .blur(radius: contentHasScrolled ? 10 : 0)
                .opacity(contentHasScrolled ? 1 : 0)
            
            Text(title)
                .animatableFont(size: contentHasScrolled ? 22 : 34, weight: .bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .opacity(contentHasScrolled ? 0.7 : 1)
            
            HStack(spacing: 16) {
                // Locations Button
                Button {
                    router.pushView(.locations)
                } label: {
                    Image(systemName: "map")
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: 36, height: 36)
                        .foregroundColor(.secondary)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 16, opacity: 0.4)
                }
                
                // Favorites Button
                Button {
                    router.pushView(.favorites)
                } label: {
                    Image(systemName: "star")
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: 36, height: 36)
                        .foregroundColor(.secondary)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 16, opacity: 0.4)
                }
                
                // Search Button
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 17, weight: .bold))
                        .frame(width: 36, height: 36)
                        .foregroundColor(.secondary)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 16, opacity: 0.4)
                }
                .sheet(isPresented: $showSheet) {
                    SearchView(viewModel: SearchViewModel())
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
        }
        .offset(y: model.showNav ? 0 : -120)
        .accessibility(hidden: !model.showNav)
        .offset(y: contentHasScrolled ? -16 : 0)
    }
}

class NavigationBarModel: ObservableObject {
    // Navigation Bar
    @Published var showNav: Bool = true
}
