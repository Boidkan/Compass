//
//  String+Formatting.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import Foundation

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: Foundation.CharacterSet.whitespacesAndNewlines)
    }
}
