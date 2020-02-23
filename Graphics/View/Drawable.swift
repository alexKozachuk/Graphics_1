//
//  Drawable.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

protocol Drawable {
    func draw()
}

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
}
