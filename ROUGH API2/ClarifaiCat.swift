//
//  ClarifaiCat.swift
//  ROUGH API2
//
//  Created by mac on 6/6/21.
//

import UIKit

struct ClarifaiCat {
    let name: String
    let probability: CGFloat
    
    var percentage: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        let certaintyNumber = NSNumber(value: Float(probability))
        
        return formatter.string(from: certaintyNumber) ?? "0%"
    }
    

}
