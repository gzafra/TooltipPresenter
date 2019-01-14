//
//  TooltipManager.swift
//  TooltipPresenter
//
//  Created by Guillermo Zafra on 10/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import Foundation

public protocol TooltipManagerDelegate: class {
    func didDismiss(tooltip: Tooltip)
    func shouldDisplay(tooltip: Tooltip) -> Bool
}

public class TooltipManager {
    
    private unowned let viewController: UIViewController
    private weak var presentedTooltipController: UIViewController?
    
    var activeTooltip: Tooltip?
    public weak var delegate: TooltipManagerDelegate?
    
    /// Initalises the manager for a given View Controller that will be used to add the overlay to its root view.
    public init(forController viewController: UIViewController) {
        self.viewController = viewController
    }
    
    /// Shows a tooltip that highlights the provided 'view'
    public func show(tooltip: Tooltip, for view: UIView, animated: Bool = true) throws {
        guard let globalPoint = view.superview?.convert(view.frame.origin, to: viewController.view) else {
            print("WARNING: View not contained in the view hierachy. Tooltip will not show.")
            throw TooltipError.outOfBounds
        }
        try show(tooltip: tooltip, on: CGRect(origin: globalPoint, size: view.frame.size))
    }
    
    /// Shows a tooltip that highlights the provided frame 'rect'
    public func show(tooltip: Tooltip, on rect: CGRect, animated: Bool = true) throws {
        // Check whether should display tooltip
        guard shouldDisplay(tooltip: tooltip) else {
            throw TooltipError.disallowed
        }
        
        // Checks tooltip has not shown before and there isn't another tooltip showing (atomic)
        guard !tooltip.type.hasShown, presentedTooltipController == nil else { return }
        
        guard let vc = createTooltipViewController(with: tooltip, highlighting: rect) else {
            // TODO: Throw error
            return
        }
        
        presentedTooltipController = vc
        activeTooltip = tooltip
        
        viewController.present(vc, animated: true, completion: nil)
    }
    
    private func shouldDisplay(tooltip: Tooltip) -> Bool {
        // Ask delegate if we should display tooltip, assume we can if there is no delegate
        return delegate?.shouldDisplay(tooltip: tooltip) ?? true
    }
    
    /// Removes the current showing tooltip only if matches the provided type
    public func hideTooltip(type: TooltipType) {
        if let activeTooltip = activeTooltip, type.key == activeTooltip.type.key {
            hideTooltip(activeTooltip)
        }
    }
    
    /// Removes the current showing tooltip from view, if any
    public func hideTooltip(_ tooltip: Tooltip) {
        presentedTooltipController?.dismiss(animated: true, completion: nil)
        presentedTooltipController = nil // Allows another tooltip to be shown
        delegate?.didDismiss(tooltip: tooltip)
    }
    
    // MARK: - Overlay creation methods
    private func createTooltipViewController(with tooltip: Tooltip, highlighting maskedRect: CGRect) -> TooltipViewController? {
        let overlay = TooltipViewController(tooltip: tooltip, area: maskedRect, parentFrame: viewController.view.frame)
        overlay?.delegate = self
        return overlay
    }
}

// MARK: - TooltipViewControllerDelegate
extension TooltipManager: TooltipViewControllerDelegate {
    func didDismiss(tooltip: Tooltip) {
        
        if let activeTooltip = activeTooltip {
            hideTooltip(activeTooltip)
            self.activeTooltip = nil
        }

        // Set to not show again
        UserDefaults.standard.set(true, forKey: tooltip.type.key)
    }
    
    func didAction(tooltip: Tooltip) {
        tooltip.callback?()
        didDismiss(tooltip: tooltip)
    }
}
