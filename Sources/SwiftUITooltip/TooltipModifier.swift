//
//  Tooltip.swift
//
//  Created by Antoni Silvestrovic on 19/10/2020.
//  Copyright © 2020 Quassum Manus. All rights reserved.
//

import SwiftUI

public struct TooltipModifier<TooltipContent: View>: ViewModifier {
    private let enabled: Bool
    private let config: TooltipConfig
    private let content: TooltipContent
    private let arrowOffsetX: CGFloat?
    private var arrowOffsetY: CGFloat {
        (contentHeight / 2 + config.arrowHeight / 2) * (config.side == .top ? 1 : -1)
    }

    // MARK: - Local state

    @State private var contentWidth: CGFloat = .zero
    @State private var contentHeight: CGFloat = .zero

    // MARK: - Initialisers

    public init(
        enabled: Bool,
        config: TooltipConfig,
        arrowOffsetX: CGFloat?,
        @ViewBuilder content: @escaping () -> TooltipContent
    ) {
        self.enabled = enabled
        self.config = config
        self.arrowOffsetX = arrowOffsetX
        self.content = content()
    }

    // MARK: - Body Properties

    public func body(content: Content) -> some View {
        content
            .overlay(enabled ? tooltipBody : nil)
    }

    private var tooltipBody: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: config.borderRadius, style: .circular)
                    .stroke(config.backgroundColor)
                    .frame(width: contentWidth, height: contentHeight)
                    .background(
                        RoundedRectangle(cornerRadius: config.borderRadius)
                            .foregroundColor(config.backgroundColor)
                    )

                ZStack {
                    content
                        .padding(.horizontal, config.horizontalPadding)
                        .padding(.vertical, config.verticalPadding)
                        .fixedSize(horizontal: true, vertical: true)
                }
                .background(sizeMeasurer)
                .overlay(arrowView(in: geometry))
            }
            .offset(x: offsetHorizontal(geometry), y: offsetVertical(geometry))
            .zIndex(config.zIndex)
        }
    }
}

// MARK: - Computation Helpers

private extension TooltipModifier {
    func offsetHorizontal(_ geometry: GeometryProxy) -> CGFloat {
        (geometry.size.width - contentWidth) / 2
    }

    func offsetVertical(_ geometry: GeometryProxy) -> CGFloat {
        switch config.side {
        case .top:
            return -(contentHeight + config.margin + config.arrowHeight)
        case .bottom:
            return geometry.size.height + config.margin + config.arrowHeight
        }
    }

    func calculateArrowOffsetX(in geometry: GeometryProxy) -> CGFloat {
        let limit = (contentWidth / 2) - config.arrowWidth
        let possibleOffset: CGFloat = {
            if let arrowOffsetX {
                return arrowOffsetX - geometry.frame(in: .global).midX
            } else {
                return .zero
            }
        }()
        var offSetX = possibleOffset

        if possibleOffset <= -limit {
            offSetX = -limit
        } else if possibleOffset >= limit {
            offSetX = limit
        }
        return offSetX
    }
}

// MARK: - View Helpers

private extension TooltipModifier {
    var sizeMeasurer: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    self.contentWidth = geometry.size.width
                    self.contentHeight = geometry.size.height
                }
        }
    }

    func arrowView(in geometry: GeometryProxy) -> some View {
        return AnyView(arrowShape(angle: config.side.getArrowAngleRadians(), borderColor: config.backgroundColor)
            .background(arrowShape(angle: config.side.getArrowAngleRadians()))
            .frame(width: config.arrowWidth, height: config.arrowHeight)
            .foregroundColor(config.backgroundColor)
        )
        .frame(width: config.arrowWidth, height: config.arrowHeight)
        .offset(
            x: calculateArrowOffsetX(in: geometry),
            y: CGFloat(Int(arrowOffsetY))
        )
    }

    func arrowShape(angle: Double, borderColor: Color? = nil) -> AnyView {
        let shape = Arrow()
            .rotation(Angle(radians: angle))
        if let borderColor {
            return AnyView(shape.stroke(borderColor))
        }
        return AnyView(shape)
    }
}
