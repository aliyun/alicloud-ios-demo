//
//  mpushExtensionBundle.swift
//  mpushExtension
//
//  Created by Miracle on 2025/3/26.
//  Copyright © 2025 alibaba. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct mpushExtensionBundle: WidgetBundle {
    var body: some Widget {
        mpushExtension()
        mpushTakeoutLiveActivity()
        mpushTaxiLiveActivity()
    }
}
