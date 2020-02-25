//
//  CGPoint+Extension.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

import CoreGraphics
import UIKit

extension CGPoint {
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    func length(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    func tang(with point: CGPoint) -> CGFloat {
        return point.x - x / point.y / y
    }
    
    func vector(point: CGPoint) -> CGPoint{
        return CGPoint(x: point.x - self.x , y: point.y - self.y)
    }
    
}

extension CGFloat {
    
    func isLess(than value: CGFloat, accuracy: CGFloat = 1e-7) -> Bool {
        let distanceToValue = distance(to: value)
        return abs(distanceToValue) < accuracy || distanceToValue > 0
    }
    
}

extension CGRect {
    
    var center: CGPoint {
        let x = minX + width / 2
        let y = minY + height / 2
        
        return CGPoint(x: x, y: y)
    }
    
}

extension UIBezierPath {
    
    func moveTo(x: CGFloat, y: CGFloat) {
        move(to: CGPoint(x: x, y: y))
    }
    
    func lineTo(x: CGFloat, y: CGFloat) {
        self.addLine(to: CGPoint(x: x, y: y))
    }
    
    convenience init(lines: [Line]) {
        self.init()
        
        lines.forEach { line in
            move(to: line.start)
            addLine(to: line.end)
        }
    }
    
}

class Equation { }

extension Equation {
    
    static func circle(radius: CGFloat, t: CGFloat) -> CGPoint {
        
        let x = radius * cos(t)
        let y = radius * sin(t)
        
        return CGPoint(x: x, y: y)
    }
    
}
