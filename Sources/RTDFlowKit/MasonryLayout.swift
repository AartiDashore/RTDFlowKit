//
//  MasonryLayout.swift
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

/// A Pinterest-style staggered-column layout. Items are placed into whichever
/// column currently has the least accumulated height, so uneven item heights
/// balance out across columns instead of leaving ragged gaps.
///
/// Children can opt into spanning multiple columns with `.spanColumns(_:)`.
///
/// ```swift
/// MasonryLayout(columns: 2, spacing: 8) {
///     ForEach(photos) { photo in
///         PhotoCell(photo)
///     }
/// }
/// ```
public struct MasonryLayout: Layout {

    /// Number of columns to balance items across.
    public var columns: Int

    /// Spacing between items, both horizontally and vertically.
    public var spacing: CGFloat

    public init(columns: Int = 2, spacing: CGFloat = 8) {
        self.columns = max(1, columns)
        self.spacing = spacing
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        guard let containerWidth = proposal.width, !subviews.isEmpty else {
            return .zero
        }

        let placement = computePlacement(containerWidth: containerWidth, subviews: subviews)
        let height = placement.columnHeights.max() ?? 0

        return CGSize(width: containerWidth, height: height)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        guard !subviews.isEmpty else { return }

        let placement = computePlacement(containerWidth: bounds.width, subviews: subviews)

        for frame in placement.frames {
            subviews[frame.index].place(
                at: CGPoint(x: bounds.minX + frame.origin.x, y: bounds.minY + frame.origin.y),
                anchor: .topLeading,
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    // MARK: - Placement computation

    private struct ItemFrame {
        let index: Int
        let origin: CGPoint
        let size: CGSize
    }

    private struct Placement {
        let frames: [ItemFrame]
        let columnHeights: [CGFloat]
    }

    private func computePlacement(containerWidth: CGFloat, subviews: Subviews) -> Placement {
        let columnWidth = (containerWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)
        var columnHeights = [CGFloat](repeating: 0, count: columns)
        var frames: [ItemFrame] = []

        for (index, subview) in subviews.enumerated() {
            let span = min(subview.columnSpan, columns)
            let itemWidth = columnWidth * CGFloat(span) + spacing * CGFloat(span - 1)

            let proposedSize = ProposedViewSize(width: itemWidth, height: nil)
            let itemSize = subview.sizeThatFits(proposedSize)

            let startColumn = bestStartingColumn(span: span, columnHeights: columnHeights)

            let x = CGFloat(startColumn) * (columnWidth + spacing)
            let y = (startColumn..<(startColumn + span))
                .map { columnHeights[$0] }
                .max() ?? 0

            frames.append(ItemFrame(index: index, origin: CGPoint(x: x, y: y), size: CGSize(width: itemWidth, height: itemSize.height)))

            let newHeight = y + itemSize.height + spacing
            for c in startColumn..<(startColumn + span) {
                columnHeights[c] = newHeight
            }
        }

        return Placement(frames: frames, columnHeights: columnHeights)
    }

    /// Finds the starting column index for an item of the given span that
    /// minimizes the resulting max height across the columns it would occupy.
    private func bestStartingColumn(span: Int, columnHeights: [CGFloat]) -> Int {
        guard span < columns else { return 0 }

        var bestStart = 0
        var bestHeight = CGFloat.infinity

        for start in 0...(columns - span) {
            let maxInRange = (start..<(start + span))
                .map { columnHeights[$0] }
                .max() ?? 0

            if maxInRange < bestHeight {
                bestHeight = maxInRange
                bestStart = start
            }
        }

        return bestStart
    }
}
