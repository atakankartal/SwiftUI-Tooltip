//
//  TooltipConfig.swift
//
//  Created by Antoni Silvestrovic on 24/10/2020.
//  Copyright © 2020 Quassum Manus. All rights reserved.
//

import SwiftUI

public struct TooltipConfig {
    public var side: TooltipSide = .bottom
    public var margin: CGFloat = 8
    public var zIndex: Double = 10000

    public var borderRadius: CGFloat = 4
    public var borderRadiusStyle: RoundedCornerStyle = .circular
    public var borderWidth: CGFloat = 1
    public var borderColor: Color = Color.black
    public var backgroundColor: Color = Color.black

    public var horizontalPadding: CGFloat = 12
    public var verticalPadding: CGFloat = 8

    public var arrowWidth: CGFloat = 12
    public var arrowHeight: CGFloat = 6

    public init() {}
}
