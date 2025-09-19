//
//  SectionRowView.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 18/09/25.
//


import SwiftUI

struct SectionRowView: View {
    var section: SectionRowModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let url = URL(string: section.image) {
                AsyncImageView(url: url)
                    .frame(width: 40, height: 40)
                    .mask(Circle())
                    .padding(12)
                    .background(Color(UIColor.systemBackground).opacity(0.3))
                    .mask(Circle())
                    .overlay(CircularView(value: section.progress))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(section.subtitle)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                Text(section.title)
                    .fontWeight(.semibold)
                Text(section.text)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                ProgressView(value: section.progress)
                    .accentColor(.white)
            }
            Spacer()
            
            // Favorite button
            FavoriteButton(characterId: section.id)
        }
    }
}

struct SectionRowModel: Identifiable {
    let id: Int
    var title: String
    var subtitle: String
    var text: String
    var image: String
    var progress: CGFloat
}
