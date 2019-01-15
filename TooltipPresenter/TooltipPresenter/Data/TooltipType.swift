//
//  TooltipType.swift
//  TooltipPresenter
//
//  Created by Guillermo Zafra on 10/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import Foundation

public protocol TooltipType {
    var helpText: String { get }
    var buttonText: String { get }
    var hasShown: Bool { get set }
    var key: String { get }
}

