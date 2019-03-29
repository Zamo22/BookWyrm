//
//  ArrayExtension.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/26.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation

extension Array {

    subscript (randomPick n: Int) -> [Element] {
        var indices = [Int](0..<count)
        var randoms = [Int]()
        for _ in 0..<n {
            randoms.append(indices.remove(at: Int(arc4random_uniform(UInt32(indices.count)))))
        }
        return randoms.map { self[$0] }
    }
}
