//
//  StageRow.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

struct StageRow: View {

    let isSelected: Bool
    private let test: StageState.StageType

    init(test: StageState.StageType, isSelected: Bool) {
        self.test = test
        self.isSelected = isSelected
    }

    var body: some View {
        let title = self.test.rawValue.capitalizingFirstLetter()

        let text = Text(title)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .listRowInsets(EdgeInsets(top: 4, leading: 55, bottom: 4, trailing: 8))
            .multilineTextAlignment(.leading)

        if self.isSelected {
            return text.font(Font.body.bold())
        } else {
            return text.font(Font.body)
        }
    }
}

struct StageRow_Previews: PreviewProvider {
    static var previews: some View {
        StageRow(test: .splitSurface, isSelected: false)
    }
}

private extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
