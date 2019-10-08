//
//  SwiftImage+Coder.swift
//  Pods
//
//  Created by 李世举 on 2019/9/29.
//

import Foundation

var isDecodedForDisplayKey = 102

extension SwiftImage {
    var isDecodedForDisplay: Bool {
        set {
            objc_setAssociatedObject(self, &isDecodedForDisplayKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if self.images != nil && self.images!.count > 1{
                return true
            }
            if let rs = objc_getAssociatedObject(self, &isDecodedForDisplayKey) as? Bool {
                return rs
            }
            return false
        }
    }
}
