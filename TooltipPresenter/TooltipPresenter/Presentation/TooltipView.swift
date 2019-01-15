//
//  TooltipView.swift
//  TooltipPresenter
//
//  Created by Guillermo Zafra on 10/12/2018.
//  Copyright © 2018 Guillermo Zafra. All rights reserved.
//

import UIKit

typealias CGCircle = (point: CGPoint, radius: CGFloat)

class TooltipView: UIView {
    // MARK: - Layout
    private struct DefaultLayout: TooltipLayout {
        let sidePadding: CGFloat = 24.0
        let okayLabelTopPadding: CGFloat = 12.0
        let tooltipVerticalSpace: CGFloat = 30.0
        let overlayColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let highlightWidth: CGFloat = 12.0
        let highlightColor: UIColor = UIColor.white.withAlphaComponent(0.3)
        var buttonFont: UIFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        var tipFont: UIFont = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
        var buttonTextColor: UIColor = UIColor.white.withAlphaComponent(0.5)
        var tipTextColor: UIColor = UIColor.white
        var maskSpacing: CGFloat = 5.0
    }
    
    // MARK: - Properties
    
    private let passingThroughArea: CGRect
    private let containerView = UIView()
    private let layout: TooltipLayout
    let okLabel = UILabel()
    
    // MARK: - Lifecycle
    
    init(tooltip: Tooltip, frame: CGRect, allowingThrough rect: CGRect, layout: TooltipLayout = DefaultLayout()) {
        self.passingThroughArea = rect
        self.layout = layout
        super.init(frame: frame)
        
        switch tooltip.displayMode {
        case .circle:
            setupCircleOverlay()
        case .rect:
            setupRectOverlay()
        }
        
        setupContainer()
        setupHelperLabel(with: tooltip.type.helpText, buttonText: tooltip.type.buttonText, aligment: tooltip.aligment)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCircleOverlay() {
        let radius = min(passingThroughArea.width, passingThroughArea.height)/2 // To fit
        let circle = (point: CGPoint(x: passingThroughArea.origin.x + passingThroughArea.width/2,
                                     y: passingThroughArea.origin.y + passingThroughArea.height/2),
                      radius: radius)
        
        backgroundColor = layout.overlayColor
        
        let path = CGMutablePath()
        path.addArc(center: circle.point,
                    radius: circle.radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        layer.mask = maskLayer
        clipsToBounds = true
        
        // Highlighted border
        let borderLayer = CAShapeLayer()
        let highLight = CGMutablePath()
        highLight.addArc(center: circle.point,
                         radius: circle.radius + layout.highlightWidth,
                         startAngle: 0.0,
                         endAngle: 2.0 * .pi,
                         clockwise: false)
        borderLayer.path = highLight
        borderLayer.fillRule = CAShapeLayerFillRule.evenOdd
        borderLayer.fillColor = layout.highlightColor.cgColor
        
        layer.addSublayer(borderLayer)
    }
    
    private func setupRectOverlay() {
        backgroundColor = layout.overlayColor
        
        let maskedArea = passingThroughArea.rectByAdding(margin: layout.maskSpacing)
        // Masked area
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: frame.size))
        let cornerRadius = min(maskedArea.size.width, maskedArea.size.height) * 0.2
        path.addRoundedRect(in: maskedArea, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        layer.mask = maskLayer
        clipsToBounds = true
        
        // Highlighted border
        let borderLayer = CAShapeLayer()
        let highlightCornerRadius = min(maskedArea.size.width+layout.highlightWidth, maskedArea.size.height+layout.highlightWidth) * 0.2
        borderLayer.path = CGPath(roundedRect: CGRect(x: maskedArea.origin.x-layout.highlightWidth,
                                                      y: maskedArea.origin.y-layout.highlightWidth,
                                                      width: maskedArea.size.width+layout.highlightWidth*2,
                                                      height: maskedArea.size.height+layout.highlightWidth*2),
                                  cornerWidth: highlightCornerRadius,
                                  cornerHeight: highlightCornerRadius,
                                  transform: nil)
        borderLayer.fillRule = CAShapeLayerFillRule.evenOdd
        borderLayer.fillColor = layout.highlightColor.cgColor
        layer.addSublayer(borderLayer)
    }
    
    private func setupContainer() {
        // Placeholder that will have the frame of the view the tooltip is attached to. Used for auto-layout
        let placeHolder = UIView(frame: passingThroughArea)
        addSubview(placeHolder)
        
        // Container view that contains the helper and okay labels
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // -- Constraints --
        
        // Set placehodler layout size according to frame
        addConstraintsWithFormat("H:|-\(passingThroughArea.origin.x)-[v0(\(passingThroughArea.size.width))]", views: placeHolder)
        addConstraintsWithFormat("V:|-\(passingThroughArea.origin.y)-[v0(\(passingThroughArea.size.height))]", views: placeHolder)
        
        // Container
        addConstraintsWithFormat("H:|-\(layout.sidePadding)-[v0]-\(layout.sidePadding)-|", views: containerView)
        let distanceToCenterY = placeHolder.frame.origin.y - frame.height/2
        if distanceToCenterY > 0 { // Lower part, tooltip shows above
            placeHolder.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: layout.tooltipVerticalSpace).isActive = true
        }else{  // Upper part, tooltip shows below
            containerView.topAnchor.constraint(equalTo: placeHolder.bottomAnchor, constant: layout.tooltipVerticalSpace).isActive = true
        }
    }
    
    private func setupHelperLabel(with tipText: String, buttonText: String, aligment: NSTextAlignment) {
        
        // Helper label
        let tipLabel = UILabel()
        tipLabel.font = layout.tipFont
        tipLabel.textColor = layout.tipTextColor
        tipLabel.textAlignment = aligment
        tipLabel.numberOfLines = 0
        tipLabel.text = tipText
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tipLabel)
        
        // Okay label
        okLabel.font = layout.buttonFont
        okLabel.textColor = layout.buttonTextColor
        okLabel.textAlignment = aligment
        okLabel.text = buttonText
        okLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(okLabel)
        
        
        // -- Constraints --
        
        // Tip & okay labels
        containerView.addConstraintsWithFormat("H:|-[v0]-|", views: tipLabel)
        containerView.addConstraintsWithFormat("H:|-[v0]-|", views: okLabel)
        containerView.addConstraintsWithFormat("V:|-0-[v0]-\(layout.okayLabelTopPadding)-[v1]-0-|", views: tipLabel, okLabel)
    }
}

fileprivate extension UIView {
    @discardableResult func addConstraintsWithFormat(_ format: String, views: UIView...) -> [NSLayoutConstraint] {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary)
        addConstraints(constraints)
        
        return constraints
    }
}
