# RTDFlowKit

**Author:** Aarti Dashore
**Copyright © 2026 Aarti Dashore. All rights reserved.** See [LICENSE](./LICENSE).

Two custom SwiftUI layouts built on the `Layout` protocol (iOS 16+):
`FlowLayout` (tag-cloud style wrapping) and `MasonryLayout` (Pinterest-style
staggered columns) — the kind of layout Apple's `HStack`/`VStack`/`LazyVGrid`
don't cover natively, and that most apps still fake with `GeometryReader`
hacks.

## Why `Layout` instead of `GeometryReader`

`GeometryReader`-based flow layouts require a two-pass render (measure, then
re-layout) and tend to flicker or mis-measure on first appearance. The
`Layout` protocol gives a proper `sizeThatFits` / `placeSubviews` contract
that SwiftUI calls directly during its own layout pass — no extra render
pass, no flicker, and it composes correctly inside `LazyVStack`/`ScrollView`.

## Usage

```swift
import RTDFlowKit

// Tag cloud / chip picker
FlowLayout(spacing: 8) {
    ForEach(tags) { tag in
        TagChip(tag)
    }
}

// Pinterest-style grid, with an optional multi-column span
MasonryLayout(columns: 3, spacing: 10) {
    ForEach(photos) { photo in
        PhotoCell(photo)
            .spanColumns(photo.isFeatured ? 2 : 1)
    }
}
```

## What's in the package

| File | What it does |
|---|---|
| `FlowLayout.swift` | Row-wrapping layout; computes rows greedily based on remaining row width, then places each item. |
| `MasonryLayout.swift` | Column-balancing layout; each item goes into whichever column (or column range, for spanning items) currently has the least height. |
| `LayoutValueKeys.swift` | Custom `LayoutValueKey` + `.spanColumns(_:)` modifier, so child views can pass layout hints up to their parent — same mechanism SwiftUI itself uses for `.gridCellColumns(_:)`. |

## Demo

`/Demo` contains two SwiftUI screens:
- **Tag Picker** — selectable chips using `FlowLayout`
- **Masonry Grid** — colored cards of varying heights using `MasonryLayout`, including one card spanning 2 columns

To run: create a new iOS App target in Xcode, add this package as a local
Swift Package dependency, then add the files in `/Demo` to that target.

## Tests

`Tests/RTDFlowKitTests` covers the row-wrapping and column-balancing math
directly (row breaks on overflow, shortest-column selection, span placement)
without needing to spin up a real view hierarchy.

```bash
swift test
```

## Requirements

- iOS 16+ / macOS 13+ (needs the `Layout` protocol)
- Swift 5.9+

## License & usage

This project is © 2026 Aarti Dashore, all rights reserved. It's shared
publicly so it can be reviewed as part of my engineering portfolio — not
as open-source software. Please don't copy this code into your own
projects, resubmit it as your own work, or strip the attribution headers
from the source files. See [LICENSE](./LICENSE) for the full terms, and
feel free to reach out if you'd like permission to use any part of it.

Every source file in `Sources/RTDFlowKit` carries this same notice in its
header comment, so authorship stays attached to the code itself, not just
this README.
