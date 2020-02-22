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
