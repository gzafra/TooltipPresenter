//
//  TooltipLayout.swift
//  TooltipPresenter
//
//  Created by Guillermo Zafra on 18/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import Foundation

public protocol TooltipLayout {
    var sidePadding: CGFloat { get }
    var okayLabelTopPadding: CGFloat { get }
    var tooltipVerticalSpace: CGFloat { get }
    var overlayColor: UIColor  { get }
    var highlightWidth: CGFloat  { get }
    var highlightColor: UIColor  { get }
    var buttonFont: UIFont { get }
    var buttonTextColor: UIColor { get }
    var tipFont: UIFont { get }
    var tipTextColor: UIColor { get }
}
