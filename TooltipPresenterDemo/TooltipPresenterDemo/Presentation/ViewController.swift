//
//  ViewController.swift
//  TooltipPresenterDemo
//
//  Created by Guillermo Zafra on 10/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import UIKit
import TooltipPresenter

class ViewController: UIViewController {
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    
    lazy var tooltipPresenter: TooltipManager = {
        let tooltipPresenter = TooltipManager(forController: self)
        tooltipPresenter.delegate = self
        return tooltipPresenter
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            self.presentButtonTooltip()
        }
    }

    func presentButtonTooltip() {
        let tooltip = Tooltip(type: DemoTooltipType.testButton,
                              displayMode: TooltipDisplayMode.rect(cornerRadius: 5),
                              aligment: NSTextAlignment.center,
                              callback: {
                                
        })
        
        do {
            try tooltipPresenter.show(tooltip: tooltip, for: testButton)
        } catch {
            UIAlertController.show(title: "Error", message: "Could not present tooltip", in: self)
        }
    }

}

fileprivate extension UIAlertController {
    static func show(title: String?, message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        viewController.show(alert, sender: nil)
    }
}

extension ViewController: TooltipManagerDelegate {
    func didDismiss(tooltip: Tooltip) {
        // Uncomment and edit to not display tooltip again when desired
//        tooltip.type.hasShown = true
    }
    
    func shouldDisplay(tooltip: Tooltip) -> Bool {
        return presentedViewController == nil
    }
    
    
}

