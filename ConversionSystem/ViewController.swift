//
//  ViewController.swift
//  ConversionSystem
//
//  Created by  on 9/30/16.
//  Copyright © 2016 UHCL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //View 1
    @IBOutlet weak var wcView: UIView!
    
    //View 2
    @IBOutlet weak var convertView: UIView!

    @IBOutlet weak var numText: UITextField!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var segVal: UISegmentedControl!
    
    @IBOutlet weak var converToBase: UIPickerView!
    
    @IBOutlet weak var result: UILabel!
    
    var selectedRow = 0
    let baseConverter = BaseConverter()
    
    var currentStepperVal : Double = 0.0
    var regex : String = "01"
    
    var baseOptionList = ["Display in Binary", "Display in Decimal", "Display in Hexadecimal", "Display in Octal", "Display in all four bases"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wcView.hidden = false
        convertView.hidden = true
        if !convertView.hidden {
            numText.becomeFirstResponder()
        }
        segVal.selectedSegmentIndex = 0
        self.converToBase.dataSource = self
        self.converToBase.delegate = self
        self.numText.delegate = self
        
        currentStepperVal = stepper.minimumValue
        
    }
    
    // Open new View
    @IBAction func enter(sender: UIButton) {
        wcView.hidden = true
        convertView.hidden = false
        numText.becomeFirstResponder()
        converToBase.reloadAllComponents()
    }
    
    // Go back to previous page
    @IBAction func reset(sender: UIButton) {
        wcView.hidden = false
        convertView.hidden = true
        numText.resignFirstResponder()
        
        numText.text = ""
        result.text = ""
        segVal.selectedSegmentIndex = 0
        converToBase.selectRow(0, inComponent: 0, animated: true)
    }
    
    // TextField Validation for correct string
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let inverSet = NSCharacterSet(charactersInString:regex).invertedSet
        let components = string.componentsSeparatedByCharactersInSet(inverSet)
        let filtered = components.joinWithSeparator("")
        return string == filtered
    }
    
    
    // Stepper
    @IBAction func minMaxStepper(sender: UIStepper) {
        numText.resignFirstResponder()
        if !numText.text!.isEmpty{
            
            let convertToDecimal = String(numText.text!)
            
            let numberOfDigits = convertToDecimal.characters.count
            
            var decimal : Int
            var changedDecimal : String
            switch segVal.selectedSegmentIndex {
            case 0:
                baseConverter.setStringValues(convertToDecimal)
                decimal = Int(baseConverter.binToDec())!
            case 2:
                baseConverter.setStringValues(convertToDecimal)
                decimal = Int(baseConverter.hexToDec())!
            case 3:
                baseConverter.setIntValues(Int(convertToDecimal)!)
                decimal = Int(baseConverter.octToDec())!
            default:
                decimal = Int(convertToDecimal)!
                break;
            }
            
            if sender.value > currentStepperVal {
                
                decimal = decimal + 1
                currentStepperVal = sender.value
            }else{
                
                decimal = decimal - 1
                currentStepperVal = sender.value
            }
            
            switch segVal.selectedSegmentIndex {
            case 0:
                baseConverter.setIntValues(decimal)
                changedDecimal = baseConverter.decToBin()
                let decimalDigits = changedDecimal.characters.count
                let diff = numberOfDigits - decimalDigits
                if diff > 0 {
                    let t = "%0\(numberOfDigits)d"
                    changedDecimal = String(format: "\(t)", Int(changedDecimal)!)
                    numText.text = changedDecimal
                }else{
                    numText.text = String(changedDecimal)
                }
            case 2:
                baseConverter.setIntValues(decimal)
                changedDecimal = baseConverter.decToHex()
                numText.text = String(changedDecimal)
            case 3:
                baseConverter.setIntValues(decimal)
                changedDecimal = baseConverter.decToOct()
                numText.text = String(changedDecimal)
            default:
                changedDecimal = String(decimal)
                numText.text = String(changedDecimal)
                break;
            }
            
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Enter Number", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    //Segment
    @IBAction func baseOptions(sender: UISegmentedControl) {
        numText.becomeFirstResponder()
        switch segVal.selectedSegmentIndex {
        case 0:
            numText.text = ""
            regex = "01"
            numText.placeholder = "Please enter a Binary value"
        case 1:
            numText.text = ""
            regex = "0123456789"
            numText.placeholder = "Please enter a Decimal value"
        case 2:
            numText.text = ""
            regex = "0123456789ABCDEFabcdef"
            numText.placeholder = "Please enter a Hexadecimal value"
        case 3:
            numText.text = ""
            regex = "01234567"
            numText.placeholder = "Please enter a Octal value"
        default:
            break;
        }

    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return baseOptionList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return baseOptionList[row]
    }

    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        numText.resignFirstResponder()
        if !numText.text!.isEmpty{
            let numberValue = String(numText.text!)
            
            
            switch selectedRow{
            case 0:
                if (segVal.selectedSegmentIndex == 1){
                    baseConverter.setIntValues(Int(numberValue)!)
                    let decimalToBinary = baseConverter.decToBin()
                    
                    result.text = "In Binary: \(decimalToBinary)"
                    
                }else if (segVal.selectedSegmentIndex == 2){
                    baseConverter.setStringValues(numberValue)
                    let hextToBinary = baseConverter.hexToBin()
                    
                    result.text = "In Binary: \(hextToBinary)"
                    
                }else if (segVal.selectedSegmentIndex == 3){
                    baseConverter.setIntValues(Int(numberValue)!)
                    let octalToBinary = baseConverter.octToBin()
                    
                    result.text = "In Binary: \(octalToBinary)"
                }else {
                    result.text = "In Binary: \(String(numberValue))"
                }
                
            case 1:
                if (segVal.selectedSegmentIndex == 0){
                    baseConverter.setStringValues(numberValue)
                    let binToDecimal = baseConverter.binToDec()
                    
                    result.text = "In Decimal: \(binToDecimal)"
                    
                }else if (segVal.selectedSegmentIndex == 2){
                    baseConverter.setStringValues(numberValue)
                    let hexToDecimal = baseConverter.hexToDec()
                    
                    result.text = "In Decimal: \(hexToDecimal)"
                    
                }else if (segVal.selectedSegmentIndex == 3){
                    baseConverter.setIntValues(Int(numberValue)!)
                    let octToDecimal = baseConverter.octToDec()
                    
                    result.text = "In Decimal: \(octToDecimal)"
                    
                }else{
                    result.text = "In Decimal: \(String(numberValue))"
                }
            case 2:
                if (segVal.selectedSegmentIndex == 0){
                    baseConverter.setStringValues(numberValue)
                    let binToHex = baseConverter.binToHex()
                    
                    result.text = "In Hexadecimal: \(String(UTF8String: binToHex)!.uppercaseString)"
                    
                }else if (segVal.selectedSegmentIndex == 1){
                    baseConverter.setIntValues(Int(numberValue)!)
                    let decToHex = baseConverter.decToHex()
                    
                    result.text = "In Hexadecimal: \(String(UTF8String: decToHex)!.uppercaseString)"
                    
                }else if (segVal.selectedSegmentIndex == 3 ){
                    baseConverter.setIntValues(Int(numberValue)!)
                    let octalToHex = baseConverter.octToHex()
                    
                    result.text = "In Hexadecimal: \(String(UTF8String: octalToHex)!.uppercaseString)"
                    
                }else{
                    result.text = "In Hexadecimal: \(String(numberValue).uppercaseString)"
                }
            case 3:
                if (segVal.selectedSegmentIndex == 0){
                    baseConverter.setIntValues(Int(numberValue)!)
                    let binaryToOct = baseConverter.binToOct()
                    
                    result.text = "In Octal: \(binaryToOct)"
                    
                }else if (segVal.selectedSegmentIndex == 1){
                    baseConverter.setIntValues(Int(numberValue)!)
                    let binaryToOct = baseConverter.decToOct()
                    
                    result.text = "In Octal: \(binaryToOct)"
                    
                }else if (segVal.selectedSegmentIndex == 2){
                    baseConverter.setStringValues(numberValue)
                    let hexToOct = baseConverter.hexToOct()
                    
                    result.text = "In Octal: \(hexToOct)"
                }else{
                    result.text = "In Octal: \(String(numberValue))"
                }
                
            case 4:
                switch segVal.selectedSegmentIndex{
                case 0:
                    baseConverter.setStringValues(numberValue)
                    let binary = numberValue
                    let decimal = baseConverter.binToDec()
                    let hex = baseConverter.binToHex()
                    let octal = baseConverter.binToOct()
                    
                    result.text = "In Binary: \(binary), In Decimal: \(decimal), In Hexadecimal: \(hex.uppercaseString), In Octal: \(octal)"
                    
                case 1:
                    baseConverter.setIntValues(Int(numberValue)!)
                    let decimal = numberValue
                    let binary = baseConverter.decToBin()
                    let hex = baseConverter.decToHex()
                    let octal = baseConverter.decToOct()
                    
                    result.text = "In Binary: \(binary), In Decimal: \(decimal), In Hexadecimal: \(hex.uppercaseString), In Octal: \(octal)"
                case 2:
                    baseConverter.setStringValues(numberValue)
                    let hex = numberValue
                    let decimal = baseConverter.hexToDec()
                    let binary = baseConverter.hexToBin()
                    let octal = baseConverter.hexToOct()
                    
                    result.text = "In Binary: \(binary), In Decimal: \(decimal), In Hexadecimal: \(hex), In Octal: \(octal)"
                    
                case 3:
                    baseConverter.setIntValues(Int(numberValue)!)
                    let octal = Int(numberValue)!
                    let decimal = baseConverter.octToDec()
                    let binary = baseConverter.octToBin()
                    let hex = baseConverter.octToHex()
                    
                    result.text = "In Binary: \(binary), In Decimal: \(decimal), In Hexadecimal: \(hex.uppercaseString), In Octal: \(octal)"
                default:
                    break;
                }
            default:
                break;
            }
        }
        

    }
    
    
    // after hitting "Enter" in text field, keyboard should disappear
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // After clicking outside of text field, keyboard should disappear
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        numText.resignFirstResponder()
        self.view.endEditing(true)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

