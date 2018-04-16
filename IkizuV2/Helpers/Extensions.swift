//
//  Extensions.swift
//  IkizuV2
//
//  Created by Robin kamo on 2018-04-12.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import Foundation
import SceneKit



//The init takes a CGPOINTs parameters and calls init by converting its values to floats
extension float2 {
    init(_ v: CGPoint){
        self.init(Float(v.x), Float(v.y))
    }
}
