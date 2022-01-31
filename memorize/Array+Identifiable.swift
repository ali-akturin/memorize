//
//  Array+Identifiable.swift
//  memorize
//
//  Created by Ali Akturin on 1/30/22.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
