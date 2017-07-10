//
//  BaseConverter.swift
//  ConversionSystem
//
//  Created by  on 10/1/16.
//  Copyright © 2016 UHCL. All rights reserved.
//

import Foundation

class BaseConverter {
    
    var inputIntVal : Int
    var inputStringVal : String
    
    init(){
        inputIntVal = 0
        inputStringVal = ""
    }
    
    init(intVal : Int, _ stringVal : String){
        inputIntVal = intVal
        inputStringVal = stringVal
    }
    
    func setIntValues(intVal : Int){
        inputIntVal = intVal
    }
    
    func setStringValues(stringVal : String){
        inputStringVal = stringVal
    }
    
    
    //binary to decimal
    func binToDec() -> String{
        let decimal = Int(inputStringVal, radix:2)!
        return String(decimal)
    }
    //hex to decimal
    func hexToDec() -> String{
        let decimal = Int(inputStringVal, radix: 16)!
        return String(decimal)
    }
    //octal to decimal
    func octToDec() -> String{
        let decimal = Int(String(inputIntVal), radix: 8)!
        return String(decimal)
    }
    
    
    
    //binary to hex
    func binToHex() -> String{
        let hex = String(Int(inputStringVal, radix: 2)!, radix: 16)
        return hex
    }
    //decimal to hex
    func decToHex() -> String{
        let hex = String(inputIntVal, radix:16)
        return hex
    }
    //octal to hex
    func octToHex() -> String{
        let decimal = Int(String(inputIntVal), radix: 8)
        let hex = String(decimal!, radix:16)
        return hex
    }
    
    
    
    //decimal to binary
    func decToBin() -> String {
        let binary = String(inputIntVal, radix:2)
        return String(binary)
    }
    //hex to binary
    func hexToBin() -> String {
        let binary = String(Int(inputStringVal, radix: 16)!, radix: 2)
        return String(binary)
    }
    //octal to binary
    func octToBin() -> String {
        let ocToDec = Int(String(inputIntVal), radix: 8)
        let binary = String(ocToDec!, radix:2)
        return String(binary)
    }
    
    
    
    //binary to octal
    func binToOct() -> String{
        let decimal = Int(String(inputIntVal), radix: 2)
        let octal = String(decimal!, radix:8)
        return String(octal)
    }
    //decimal to octal
    func decToOct() -> String{
        let octal = String(inputIntVal, radix:8)
        return String(octal)
    }
    //hex to octal
    func hexToOct() -> String{
        let decimal = Int(String(inputStringVal), radix: 16)
        let octal = String(decimal!, radix:8)
        return String(octal)
    }
    
    
}