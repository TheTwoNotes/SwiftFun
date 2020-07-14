//
//  StylesSheet.swift
//  SwiftFun
//
//  Created by Gil Estes on 7/1/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import SpriteKit

struct StylesSheet: Codable {
    let fontName: String
    let fontNameItalic: String
    let fontNameBold: String
    let fontNameBoldItalic: String
    
    let fontSizeEndOfGame: Float
    let fontSizeLarge: Float
    let fontSize: Float
    let fontSizeSmall: Float

    let fontColorHex: String
    let fontColorBrightHex: String
    let fontColorNeutralHex: String
    let fontColorNeutralBrightHex: String

    let fontColorGoodHex: String
    let fontColorFairHex: String
    let fontColorWarnHex: String
    let fontColorFailHex: String
    
    let actionColorHex: String
    let narrativeColorHex: String
    let narrativeFontSize: Float
    
    let borderedButtonFontName: String
    let borderedButtonFontSize: Float
    let borderButtonCornerRadius: Float
    
    let gameCreditFontSize: Float
}
