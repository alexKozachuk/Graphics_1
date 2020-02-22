//
//  UIBeizerPath+Extension.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

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
