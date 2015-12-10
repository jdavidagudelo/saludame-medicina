//
//  Protocol.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
struct Protocol{
    static let Formal: NSNumber! = 1
    static let Neutral: NSNumber! = 2
    static let Informal: NSNumber! = 3
    static let FormalText: String! = NSLocalizedString("formalProtocolText", tableName: "localization",
        comment: "Formal protocol text")
    static let InformalText: String! = NSLocalizedString("informalProtocolText", tableName: "localization",
        comment: "Informal protocol text")
    static let NeutralText: String! = NSLocalizedString("neutralProtocolText", tableName: "localization",
        comment: "Neutral protocol text")
}