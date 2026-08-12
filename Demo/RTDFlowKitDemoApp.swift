//
//  RTDFlowKitDemoApp.swift
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

/// Entry point for the demo app. Not part of the RTDFlowKit package itself —
/// this target just consumes it to show both layouts in action.
///
/// To try it: create a new iOS App target in Xcode, add RTDFlowKit as a local
/// package dependency, and drop this folder's files into that target.
@main
struct RTDFlowKitDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    NavigationLink("Tag Picker (FlowLayout)") {
                        TagPickerDemoView()
                    }
                    NavigationLink("Masonry Grid (MasonryLayout)") {
                        MasonryDemoView()
                    }
                }
                .navigationTitle("RTDFlowKit Demo")
            }
        }
    }
}
