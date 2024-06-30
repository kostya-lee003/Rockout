//
//  UIViewExtension.swift
//  Rockout
//
//  Created by Kostya Lee on 01/10/23.
//

import UIKit

extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            var newFrame = self.frame
            newFrame.origin.x = newX
            self.frame = newFrame
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            var newFrame = self.frame
            newFrame.origin.y = newY
            self.frame = newFrame
        }
    }
    
    public var frameWidth: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            var newFrame = self.frame
            newFrame.size.width = newWidth
            self.frame = newFrame
        }
    }
    
    public var frameHeight: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            var newFrame = self.frame
            newFrame.size.height = newHeight
            self.frame = newFrame
        }
    }
    public var minX: CGFloat {
        get {
            return self.frame.minX
        }
    }
    public var midX: CGFloat {
        get {
            return self.frame.midX
        }
    }
    public var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    public var minY: CGFloat {
        get {
            return self.frame.minY
        }
    }
    public var midY: CGFloat {
        get {
            return self.frame.midY
        }
    }
    public var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        } set {
            self.frame.size = newValue
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set {
            self.frame.origin = newValue
        }
    }
    
    /// EZSwiftExtensions
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }
    
    ///
    public var right: CGFloat {
        get {
            return self.x + self.frameWidth
        } set(value) {
            self.x = value - self.frameWidth
        }
    }
    
    ///
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }
    
    ///
    public var bottom: CGFloat {
        get {
            return self.y + self.frameHeight
        } set(value) {
            self.y = value - self.frameHeight
        }
    }
    
    ///
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }
    
    ///
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
}

extension UIView {
    public enum CornerPosition {
        case Top
        case Bottom
        case All
    }
    
    public func roundCorners(_ corners: CornerPosition, radius: CGFloat) {
        switch corners {
        case .Top:
            let maskPathTop = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerTop = CAShapeLayer()
            shapeLayerTop.frame = self.bounds
            shapeLayerTop.path = maskPathTop.cgPath
            self.layer.mask = shapeLayerTop
        case .Bottom:
            let maskPathBottom = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerBottom = CAShapeLayer()
            shapeLayerBottom.frame = self.bounds
            shapeLayerBottom.path = maskPathBottom.cgPath
            self.layer.mask = shapeLayerBottom
        case .All:
            let maskPathAll = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerAll = CAShapeLayer()
            shapeLayerAll.frame = self.bounds
            shapeLayerAll.path = maskPathAll.cgPath
            self.layer.mask = shapeLayerAll
        }
    }
}
