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
    
    func rotate(by angle: Angle = .degrees(0)) -> Line {
        let startX = start.x * cos(angle.radians) - start.y * sin(angle.radians)
        let startY = start.x * sin(angle.radians) + start.y * cos(angle.radians)
        let endX = end.x * cos(angle.radians) - end.y * sin(angle.radians)
        let endY = end.x * sin(angle.radians) + end.y * cos(angle.radians)
        return Line(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
    
    func move(to point: CGPoint) -> Line {
        let startX = start.x + point.x
        let startY = start.y + point.y
        let endX = end.x + point.x
        let endY = end.y + point.y
        return Line(start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
}

