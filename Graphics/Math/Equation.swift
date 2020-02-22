//
//  Equation.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreGraphics

class Equation { }

extension Equation {
    
    static func circle(radius: CGFloat, t: CGFloat) -> CGPoint {
        
        let x = radius * cos(t)
        let y = radius * sin(t)
        
        return CGPoint(x: x, y: y)
    }
    
}
