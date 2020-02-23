//
//  Line.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreGraphics

struct Line {
    let start: CGPoint
    let end: CGPoint
    
    func rotate(by angle: Angle = .degrees(0), in center: CGPoint) -> Line {
        let startX = center.x + (start.x - center.x) * cos(angle.radians) - (start.y - center.y) * sin(angle.radians)
        let startY = center.y + (start.x - center.x) * sin(angle.radians) + (start.y - center.y) * cos(angle.radians)
        let endX = center.x + (end.x - center.x) * cos(angle.radians) - (end.y - center.y) * sin(angle.radians)
        let endY = center.y + (end.x - center.x) * sin(angle.radians) + (end.y - center.y) * cos(angle.radians)
        return Line(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
    
    func move(to point: CGPoint) -> Line {
        let startX = start.x + point.x
        let startY = start.y + point.y
        let endX = end.x + point.x
        let endY = end.y + point.y
        return Line(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
    
    func scale(by scale: CGFloat) -> Line {
        let startX = start.x * scale
        let startY = start.y * scale
        let endX = end.x * scale
        let endY = end.y * scale
        return Line(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
}

