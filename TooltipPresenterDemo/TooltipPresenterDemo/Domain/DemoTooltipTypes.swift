//
//  DemoTooltipTypes.swift
//  TooltipPresenterDemo
//
//  Created by Guillermo Zafra on 18/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import Foundation
import TooltipPresenter

enum DemoTooltipType: String, TooltipType  {
    var key: String {
        return self.rawValue
    }
    
    case testButton
    case tabBarLeftItem
    case tabBarRightItem
    
    var helpText: String {
        switch self {
        case .testButton:
            return LocalizedResources.sellYourItems
        case .tabBarLeftItem:
            return LocalizedResources.findFashion
        case .tabBarRightItem:
            return LocalizedResources.favouriteItems
        }
    }
    
    var buttonText: String {
        return LocalizedResources.okayLabel
    }
    
    var hasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: self.rawValue)
        }
    }
}
