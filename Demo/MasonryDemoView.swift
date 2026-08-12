//
//  MasonryDemoView.swift
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

/// Demonstrates `MasonryLayout` as a Pinterest-style photo grid, including
/// one item that spans two columns via `.spanColumns(2)`.
struct MasonryDemoView: View {
    private struct DemoItem: Identifiable {
        let id = UUID()
        let height: CGFloat
        let color: Color
        let span: Int
    }

    private let items: [DemoItem] = [
        .init(height: 120, color: .blue, span: 1),
        .init(height: 200, color: .purple, span: 1),
        .init(height: 90, color: .orange, span: 2),
        .init(height: 160, color: .pink, span: 1),
        .init(height: 140, color: .teal, span: 1),
        .init(height: 220, color: .indigo, span: 1),
        .init(height: 100, color: .mint, span: 1),
        .init(height: 180, color: .yellow, span: 1),
    ]

    var body: some View {
        ScrollView {
            MasonryLayout(columns: 3, spacing: 10) {
                ForEach(items) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(item.color.gradient)
                        .frame(height: item.height)
                        .spanColumns(item.span)
                }
            }
            .padding()
        }
        .navigationTitle("Masonry Grid")
    }
}

#Preview {
    NavigationStack {
        MasonryDemoView()
    }
}
