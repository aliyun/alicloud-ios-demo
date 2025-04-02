//
//  mpush_liveActivity_extensionBundle.swift
//  mpush_liveActivity_extension
//
//  Created by Miracle on 2025/4/2.
//  Copyright © 2025 alibaba. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct mpush_liveActivity_extensionBundle: WidgetBundle {
    var body: some Widget {
        mpush_liveActivity_extension()
        mpushTakeoutLiveActivity()
        mpushTaxiLiveActivity()
    }
}
