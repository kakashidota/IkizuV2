//
//  PlayerClass.swift
//  IkizuV2
//
//  Created by Robin kamo on 2018-04-25.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import Firebase


class PlayerClass: NSObject {
    
    
    var positionX : Float = 0.0
    var positionY : Float = 0.0
    var positionZ : Float = 0.0
    
    
    func saveToFirebase(){
        let myref = Database.database().reference().child("bror")
        let dict = ["PosX" : self.positionX, "PosY" : self.positionY, "PosZ" : self.positionZ]
        myref.setValue(dict)
    }
}
