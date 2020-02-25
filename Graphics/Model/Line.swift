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
    
    func affine(point0: CGPoint, pointx: CGPoint, pointy: CGPoint) -> Line{
        
        let startX = (point0.x + pointx.x * start.x + pointy.x * start.y)
        let startY = (point0.y + pointx.y * start.x + pointy.y * start.y)
        let endX = (point0.x + pointx.x * end.x + pointy.x * end.y)
        let endY = (point0.y + pointx.y * end.x + pointy.y * end.y)
        let newStart = CGPoint(x: startX, y: startY)
        
        return Line(start: newStart, end: CGPoint(x: endX, y: endY))
    }
    
    func affineW(point0: CGPoint, w0: CGFloat, pointx: CGPoint, wx: CGFloat, pointy: CGPoint, wy: CGFloat) -> Line{
        
        let startX =  (point0.x * w0 + pointx.x * wx * start.x + pointy.x * wy * start.y) / (w0 + wx * start.x + wy * start.y)
        let startY = (point0.y * w0 + pointx.y * wy * start.x + pointy.y * wx * start.y) /
            (w0 + wx * start.x + wy * start.y * wy)
        let endX =  (point0.x * w0 + pointx.x * wx * end.x + pointy.x * wy * end.y) / (w0 + wx * end.x + wy * end.y)
        let endY =  (point0.y * w0 + pointx.y * wy * end.x + pointy.y * wx * end.y) /
            (w0 + wx * end.x + wy * end.y * wy)
        
        let newStart = CGPoint(x: startX, y: startY)
        
        return Line(start: newStart, end: CGPoint(x: endX, y: endY))
    }
}
