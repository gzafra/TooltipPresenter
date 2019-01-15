//
//  CGRectExtensions.swift
//  TooltipPresenter
//
//  Created by Guillermo Zafra on 15/01/2019.
//  Copyright © 2019 Guillermo Zafra. All rights reserved.
//

import Foundation

extension CGRect {
    /// Returns a rect adding a margin to its bounds, modifies origin
    func rectByAdding(margin: CGFloat) -> CGRect {
        return CGRect(x: origin.x-margin, y: origin.y-margin, width: size.width+2*margin, height: size.height+2*margin)
    }
}
