//
//  Array+Only.swift
//  memorize
//
//  Created by Ali Akturin on 1/30/22.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
