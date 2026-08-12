//
//  RTDFlowKit.md
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

# ``RTDFlowKit``

Two custom SwiftUI layouts — `FlowLayout` and `MasonryLayout` — built on
Apple's `Layout` protocol (iOS 16+).

## Overview

RTDFlowKit provides layout containers for two common UI patterns that
`HStack`, `VStack`, and `LazyVGrid` don't cover natively:

- **``FlowLayout``** wraps items left-to-right, breaking to a new row when
  the current row runs out of space — the classic "tag cloud" pattern.
- **``MasonryLayout``** arranges items into staggered, height-balanced
  columns, Pinterest-style, and supports items that span multiple columns
  via the `.spanColumns(_:)` modifier.

Both are implemented against the `Layout` protocol's `sizeThatFits` /
`placeSubviews` contract, so they participate directly in SwiftUI's own
layout pass — no `GeometryReader`, no extra render pass, no flicker.

## Topics

### Layouts

- ``FlowLayout``
- ``MasonryLayout``

### Layout Hints

- ``SwiftUI/View/spanColumns(_:)``

## Getting Started

```swift
import RTDFlowKit

FlowLayout(spacing: 8) {
    ForEach(tags) { tag in
        TagChip(tag)
    }
}

MasonryLayout(columns: 3, spacing: 10) {
    ForEach(photos) { photo in
        PhotoCell(photo)
            .spanColumns(photo.isFeatured ? 2 : 1)
    }
}
```

See the `/Demo` folder in the repository for full working examples.
