//
//  IdentificationType.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 13/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import Foundation
struct IdentificationType{
    static let Cedula : String! = NSLocalizedString("documentTypeCedula", tableName: "localization",comment: "Cedula document type")
    static let Pasaporte : String! = NSLocalizedString("documentTypePassport", tableName: "localization",comment: "Passport document type")
    static let IdentityCard : String! = NSLocalizedString("documentTypeIdentityCard", tableName: "localization",comment: "Identity card document type")
    static let CedulaExtrajeria : String! = NSLocalizedString("documentTypeCedulaExtranjeria", tableName: "localization",comment: "Cedula Extranjeria document type")
}