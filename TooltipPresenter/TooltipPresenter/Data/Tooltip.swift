//
//  Tooltip.swift
//  TooltipPresenter
//
//  Created by Guillermo Zafra on 10/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import Foundation

public typealias TooltipCallback = (()->())

public struct Tooltip {
    public let type: TooltipType
    let displayMode: TooltipDisplayMode
    let aligment: NSTextAlignment
    public let callback: TooltipCallback?
    
    public init(type: TooltipType, displayMode: TooltipDisplayMode, aligment: NSTextAlignment, callback: TooltipCallback? = nil) {
        self.type = type
        self.displayMode = displayMode
        self.aligment = aligment
        self.callback = callback
    }
}
