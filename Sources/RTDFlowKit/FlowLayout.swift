//
//  FlowLayout.swift
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

/// A layout that arranges subviews left-to-right, wrapping to a new row
/// when the current row runs out of horizontal space.
///
/// Useful for tag clouds, chip pickers, and any collection of
/// variable-width items that should flow naturally like text.
///
/// ```swift
/// FlowLayout(spacing: 8) {
///     ForEach(tags) { tag in
///         TagChip(tag)
///     }
/// }
/// ```
public struct FlowLayout: Layout {

    /// Horizontal spacing between items in the same row.
    public var horizontalSpacing: CGFloat

    /// Vertical spacing between rows.
    public var verticalSpacing: CGFloat

    public init(horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public init(spacing: CGFloat = 8) {
        self.horizontalSpacing = spacing
        self.verticalSpacing = spacing
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        let containerWidth = proposal.width ?? .infinity
        let rows = computeRows(containerWidth: containerWidth, subviews: subviews)

        let height = rows.reduce(0) { partial, row in
            partial + row.height
        } + verticalSpacing * CGFloat(max(0, rows.count - 1))

        let width = rows.map(\.width).max() ?? 0

        return CGSize(width: min(width, containerWidth), height: height)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        let rows = computeRows(containerWidth: bounds.width, subviews: subviews)

        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            for item in row.items {
                item.subview.place(
                    at: CGPoint(x: x, y: y),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(item.size)
                )
                x += item.size.width + horizontalSpacing
            }
            y += row.height + verticalSpacing
        }
    }

    // MARK: - Row computation

    private struct RowItem {
        let subview: LayoutSubview
        let size: CGSize
    }

    private struct Row {
        var items: [RowItem] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func computeRows(containerWidth: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row()
        var currentX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            let wouldExceed = currentX + size.width > containerWidth && !currentRow.items.isEmpty

            if wouldExceed {
                currentRow.width = currentX - horizontalSpacing
                rows.append(currentRow)
                currentRow = Row()
                currentX = 0
            }

            currentRow.items.append(RowItem(subview: subview, size: size))
            currentRow.height = max(currentRow.height, size.height)
            currentX += size.width + horizontalSpacing
        }

        if !currentRow.items.isEmpty {
            currentRow.width = currentX - horizontalSpacing
            rows.append(currentRow)
        }

        return rows
    }
}
