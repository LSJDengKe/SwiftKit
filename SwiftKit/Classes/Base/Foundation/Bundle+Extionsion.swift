//
//  Bundle+Extionsion.swift
//  Pods
//
//  Created by 李世举 on 2019/9/28.
//

import Foundation

extension Bundle {
    
}

//static let shareInstance:

let preferredScales: [Int] = {
    var scales: [Int] = []
    let screenScale = UIScreen.main.scale
    if screenScale <= 1 {
        scales = [1,2,3]
    }else if screenScale <= 2 {
        scales = [2,3,1]
    }else {
        scales = [3,2,1]
    }
    return scales
}()

