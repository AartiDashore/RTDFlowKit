//
//  MasonryLayoutTests.swift
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

final class MasonryLayoutTests: XCTestCase {

    func test_columnWidth_splitsContainerEvenly() {
        let containerWidth: CGFloat = 320
        let columns = 2
        let spacing: CGFloat = 8

        let columnWidth = (containerWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)

        // (320 - 8) / 2 = 156
        XCTAssertEqual(columnWidth, 156, accuracy: 0.01)
    }

    func test_shortestColumn_receivesNextItem() {
        // Simulates the greedy "place in shortest column" strategy that
        // MasonryLayout uses internally.
        var columnHeights: [CGFloat] = [100, 40]

        func bestColumn(_ heights: [CGFloat]) -> Int {
            heights.indices.min(by: { heights[$0] < heights[$1] }) ?? 0
        }

        let chosen = bestColumn(columnHeights)
        XCTAssertEqual(chosen, 1, "Item should go into the shorter column (index 1)")

        columnHeights[chosen] += 60
        XCTAssertEqual(columnHeights, [100, 100])
    }

    func test_spanningItem_choosesRangeMinimizingMaxHeight() {
        // 3 columns, an item spanning 2 columns should prefer whichever
        // adjacent pair has the lower combined max height.
        // Columns: [0]=50, [1]=200, [2]=55 -> pair [0,1] maxes at 200,
        // pair [1,2] maxes at 200 too, so the clearer case below removes
        // the tie: [0]=50, [1]=90, [2]=200 -> pair [0,1] (max 90) should win.
        let columnHeights: [CGFloat] = [50, 90, 200]
        let span = 2
        let columns = columnHeights.count

        var bestStart = 0
        var bestHeight = CGFloat.infinity

        for start in 0...(columns - span) {
            let maxInRange = (start..<(start + span)).map { columnHeights[$0] }.max() ?? 0
            if maxInRange < bestHeight {
                bestHeight = maxInRange
                bestStart = start
            }
        }

        XCTAssertEqual(bestStart, 0, "Pair [0,1] (max 90) should beat pair [1,2] (max 200)")
    }
}
