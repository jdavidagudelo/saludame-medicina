//
//  ParseJSON.swift
//  SaludameMedicina
//
//  Created by Ingenieria y Software on 18/11/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//


import Foundation

struct ParseJSON {
    //
    private var nameOfFile:String!
    private var typeOfFile:String!
    var data:NSData!
    var stringData:NSString!
    
    init(fName:String, fType:String) {
        nameOfFile = fName
        typeOfFile = fType
        parseJSONFile(nameOfFile, fileType: typeOfFile)
    }
    /// Parses a local JSON file and returns a data object
    /// - Parameters
    /// - param1 the name of the local file
    /// - param2 the extension type of the file in this case .json
    /// [JSON Documentation](
    ///  https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSJSONSerialization_Class/)
    mutating func parseJSONFile(fileName:String, fileType:String) -> NSString! {
        // Do any additional setup after loading the view, typically from a nib.
        if let path = NSBundle.mainBundle().pathForResource("\(fileName)", ofType: "\(fileType)"){
            do {
                self.data = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingUncached)
                self.stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
            } catch {
                print("error ")
            }
        }
        return self.stringData
    }
}