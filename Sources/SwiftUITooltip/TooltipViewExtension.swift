//
//  TooltipViewExtension.swift
//
//  Created by Antoni Silvestrovic on 24/10/2020.
//  Copyright © 2020 Quassum Manus. All rights reserved.
//

import SwiftUI

public extension View {
    /// Tooltip
    /// - Parameters:
    ///   - enabled: A Bool value indicates if should show tooltip or not
    ///   - config: Configuration for the Tooltip modifier
    ///   - arrowOffsetX: Only use if you want tooltip's arrow to stay at an exact location in global frame
    ///   - content: Custom content
    /// - Returns: View with tooltip applied
    func tooltip<TooltipContent: View>(
        enabled: Bool = true,
        config: TooltipConfig = TooltipConfig(),
        arrowOffsetX: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> TooltipContent
    ) -> some View {
        modifier(
            TooltipModifier(
                enabled: enabled,
                config: config,
                arrowOffsetX: arrowOffsetX,
                content: content
            )
        )
    }
}
