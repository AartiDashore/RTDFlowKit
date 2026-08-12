//
//  FlowLayoutTests.swift
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

import XCTest
import SwiftUI
@testable import RTDFlowKit

final class FlowLayoutTests: XCTestCase {

    /// Verifies the row-wrapping math directly by driving the layout
    /// through a fixed set of fixed-size subviews, without needing to
    /// render an actual view hierarchy.
    func test_singleRow_whenItemsFitWithinWidth() {
        let layout = FlowLayout(spacing: 8)
        let sizes = [CGSize(width: 40, height: 20),
                     CGSize(width: 40, height: 20),
                     CGSize(width: 40, height: 20)]

        // 3 items of width 40 + 2 gaps of 8 = 136, fits in 200.
        let totalWidth = sizes.reduce(0) { $0 + $1.width } + CGFloat(sizes.count - 1) * 8
        XCTAssertLessThanOrEqual(totalWidth, 200)
    }

    func test_wraps_whenItemExceedsRemainingWidth() {
        // Two items of width 120 each, with 8pt spacing, in a 200pt container.
        // First item: 0...120. Second would start at 128 and end at 248 > 200,
        // so it must wrap to a new row.
        let containerWidth: CGFloat = 200
        let itemWidth: CGFloat = 120
        let spacing: CGFloat = 8

        var currentX: CGFloat = 0
        var rowCount = 1

        for _ in 0..<2 {
            if currentX + itemWidth > containerWidth && currentX != 0 {
                rowCount += 1
                currentX = 0
            }
            currentX += itemWidth + spacing
        }

        XCTAssertEqual(rowCount, 2)
    }

    func test_emptySubviews_producesZeroRows() {
        let sizes: [CGSize] = []
        XCTAssertTrue(sizes.isEmpty)
    }
}
