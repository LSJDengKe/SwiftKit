//
//  URL+Extionsion.swift
//  Pods
//
//  Created by 李世举 on 2019/9/28.
//

import Foundation

extension URL {
    func appendingName(scale: CGFloat) -> URL {
        if abs(scale - 1.0) < .ulpOfOne  {
            return self
        }
        return self.appendingPathExtension(String.init(format: "%.0fx", scale))
    }
}
