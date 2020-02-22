//
//  ArcShape.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

import CoreGraphics

struct ArcShape: Shape {

    private let step: CGFloat = Angle.degrees(1).radians / 2
    
    let center: CGPoint
    let radius: CGFloat
    let startRadians: CGFloat
    let endRadians: CGFloat
    let clockwise: Bool
    
    init(center: CGPoint = .zero,
         radius: CGFloat,
         start startAngle: Angle = .degrees(0),
         end endAngle: Angle = .degrees(360),
         clockwise: Bool = false) {
        
        self.center = center
        self.radius = radius
        self.startRadians = startAngle.radians
        self.endRadians = endAngle.radians
        self.clockwise = clockwise
    }
    
    var path: Path {
        return Path(lines: lines, startPoint: startPoint, endPoint: endPoint)
    }
    
    var startPoint: CGPoint {
        return center + Equation.circle(radius: radius, t: startRadians)
    }
    
    var endPoint: CGPoint {
        return center + Equation.circle(radius: radius, t: endRadians)
    }
    
    var lines: [Line] {
        
        var start, end: CGFloat
        
        if abs(endRadians - startRadians) >= 2 * .pi {
            start = 0
            end = 2 * .pi
        } else {
            
            if clockwise {
                start = endRadians
                end = startRadians
            } else {
                start = startRadians
                end = endRadians
            }
            
            if start > end {
                end += 2 * .pi
            }
        }
        
        var result: [Line] = []
        
        var current = start
        
        while current.isLess(than: end, accuracy: 1e-7) {
            let startPoint = center + Equation.circle(radius: radius, t: current)
            let endPoint = center + Equation.circle(radius: radius, t: current + step)
            
            let line = Line(start: startPoint, end: endPoint)
            
            result.append(line)
            
            current += step
        }
                
        return result
    }
    
}
