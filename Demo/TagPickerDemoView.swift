//
//  TagPickerDemoView.swift
//  RTDFlowKit
//
//  Created by Aarti Dashore on 8/11/26.
//  Copyright © 2026 Aarti Dashore. All rights reserved.
//
//  This source file is part of the RTDFlowKit project and is provided for
//  portfolio and educational review purposes only. No license, express or
//  implied, is granted to copy, redistribute, sublicense, or use this code
//  (in whole or in part) in your own projects, portfolios, or submissions
//  without prior written permission from the author. See LICENSE for details.
//

import SwiftUI
import RTDFlowKit

/// Demonstrates `FlowLayout` as a selectable tag/chip picker —
/// the classic case that used to require a manual `GeometryReader` hack.
struct TagPickerDemoView: View {
    private let allTags = [
        "SwiftUI", "Concurrency", "Combine", "Core Data", "SwiftData",
        "Metal", "RealityKit", "WidgetKit", "App Intents", "Accessibility",
        "Testing", "Swift Macros", "Swift Package Manager"
    ]

    @State private var selected: Set<String> = ["SwiftUI", "Concurrency"]

    var body: some View {
        ScrollView {
            FlowLayout(spacing: 8) {
                ForEach(allTags, id: \.self) { tag in
                    TagChip(title: tag, isSelected: selected.contains(tag)) {
                        toggle(tag)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Tag Picker")
    }

    private func toggle(_ tag: String) {
        if selected.contains(tag) {
            selected.remove(tag)
        } else {
            selected.insert(tag)
        }
    }
}

private struct TagChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.snappy, value: isSelected)
    }
}

#Preview {
    NavigationStack {
        TagPickerDemoView()
    }
}
