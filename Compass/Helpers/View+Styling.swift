//
//  View+Styling.swift
//  Compass
//
//  Created by e on 3/17/23.
//

import SwiftUI

extension View {
    /// Hiding content this way will still effect padding
    @ViewBuilder func hideIf(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}

