//
//  LayoutValueKeys.swift
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

/// A layout-value key that lets a child view tell `MasonryLayout` how many
/// columns it should span, similar in spirit to `.gridCellColumns(_:)`.
private struct ColumnSpanKey: LayoutValueKey {
    static let defaultValue: Int = 1
}

extension View {
    /// Marks this view as spanning `count` columns inside a `MasonryLayout`.
    ///
    /// ```swift
    /// FeaturedCard(item)
    ///     .spanColumns(2)
    /// ```
    public func spanColumns(_ count: Int) -> some View {
        layoutValue(key: ColumnSpanKey.self, value: max(1, count))
    }
}

extension LayoutSubview {
    /// The column span requested via `.spanColumns(_:)`, defaulting to 1.
    var columnSpan: Int {
        self[ColumnSpanKey.self]
    }
}
