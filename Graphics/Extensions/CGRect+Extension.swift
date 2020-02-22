//
//  CGRect+Extension.swift
//  Graphics
//
//  Created by Sasha on 22/02/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

extension CGRect {
    
    var center: CGPoint {
        let x = minX + width / 2
        let y = minY + height / 2
        
        return CGPoint(x: x, y: y)
    }
    
}
