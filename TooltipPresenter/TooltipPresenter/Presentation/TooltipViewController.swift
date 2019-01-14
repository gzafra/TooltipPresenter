//
//  TooltipViewController.swift
//  TooltipPresenter
//
//  Created by Guillermo Zafra on 10/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import UIKit

protocol TooltipViewControllerDelegate: class {
    func didDismiss(tooltip: Tooltip)
    func didAction(tooltip: Tooltip)
}

class TooltipViewController: UIViewController {
    
    private let tooltip: Tooltip
    private let tooltipView: TooltipView
    weak var delegate: TooltipViewControllerDelegate?
    private let passingThroughArea: CGRect
    
    init?(tooltip: Tooltip, area: CGRect, parentFrame: CGRect) {
        self.tooltip = tooltip
        self.passingThroughArea = area
        self.tooltipView = TooltipView(tooltip: tooltip, frame: parentFrame, allowingThrough: area)
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
        
        assert(view.frame.contains(area), "allowingThrough rect is not within view bounds")
        guard view.frame.contains(area) else { return nil }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tooltipView)
        // Auto pin to superview edges
        tooltipView.translatesAutoresizingMaskIntoConstraints = false
        tooltipView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tooltipView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tooltipView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tooltipView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension TooltipViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
        // Check whether forward touch or not
        if passingThroughArea.contains(point) {
            print("Touch contained within allowed area. Allowed!")
            dismiss(animated: true, completion: nil)
            delegate?.didAction(tooltip: tooltip)
            return
        }
        
        print("Point out of allowed area. Ignoring touch!")
        guard let okLabelFrame = tooltipView.okLabel.superview?.convert(tooltipView.okLabel.frame, to: view), okLabelFrame.contains(point) else { return}
        
        dismiss(animated: true, completion: nil)
        delegate?.didDismiss(tooltip: tooltip)
    }
}

