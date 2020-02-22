//
//  Cartesinan.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import Foundation

import CoreGraphics

class CartesianToCoreGraphicsSystemCoordinatesConverter: SystemCoordinatesConverter {
    
    var coreGraphicsRect: CGRect
    var coreGraphicsRectCenter: CGPoint
    
    init(rect: CGRect = .zero) {
        self.coreGraphicsRect = rect
        self.coreGraphicsRectCenter = rect.center
    }
    
    /**
     - Parameters:
        - point: Cartesian Coordinate
     
     - Return:
        CoreGraphics Coordinate
     */
    func convert(point: CGPoint) -> CGPoint {
        
        let x = coreGraphicsRectCenter.x + point.x
        let y = coreGraphicsRectCenter.y - point.y
        
        return CGPoint(x: x, y: y)
    }
    

}
