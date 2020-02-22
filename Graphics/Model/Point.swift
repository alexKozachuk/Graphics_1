//
//  Point.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import CoreGraphics

struct UniformPoint2D {
    
    let x: CGFloat
    let y: CGFloat
    let w: CGFloat
    
    init(x: CGFloat, y: CGFloat, w: CGFloat = 1) {
        self.x = x
        self.y = y
        self.w = w
    }
}
