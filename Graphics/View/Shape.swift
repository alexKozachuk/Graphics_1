//
//  Shape.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol Shape {
    var path: Path { get }
}

extension Shape {
    
    func rotate(by angle: Angle, in center: CGPoint) -> [Line] {
        var rotateLines: [Line] = []
        
        for item in path.lines {
            rotateLines.append(item.rotate(by: angle, in: center))
        }
        
        return rotateLines
        
    }
    
    func moveTo(point: CGPoint) -> [Line] {
        var rotateLines: [Line] = []
        
        for item in path.lines {
            rotateLines.append(item.move(to: point))
        }
        
        return rotateLines
    }
    
    func scale(by scale: CGFloat) -> [Line] {
        var rotateLines: [Line] = []
        
        for item in path.lines {
            rotateLines.append(item.scale(by: scale))
        }
        
        return rotateLines
    }
    
    func affine(point0: CGPoint, pointx: CGPoint, pointy: CGPoint) -> [Line]{
        var affineLines: [Line] = []
        
        for item in path.lines {
            affineLines.append(item.affine(point0: point0, pointx: pointx, pointy: pointy))
        }
        
        return affineLines
    }
    
    func affineW(point0: CGPoint, w0: CGFloat, pointx: CGPoint, wx: CGFloat, pointy: CGPoint, wy: CGFloat) -> [Line] {
        var affineLines: [Line] = []
        
        for item in path.lines {
            affineLines.append(item.affineW(point0: point0, w0: w0, pointx: pointx, wx: wx, pointy: pointy, wy: wy))
        }
        
        return affineLines
    }
}
