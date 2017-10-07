//
//  ViewController.swift
//  ConvertIt
//
//  Created by Mia Tortolani on 9/27/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Objects & Outlets
    struct Formula {
        var conversionString: String
        var formula: (Double) -> Double
    }
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    let formulasArray = [Formula(conversionString: "Miles to Kilometers", formula: {$0 / 0.62137}),
                         Formula(conversionString: "Kilometers to Miles", formula: {$0 * 0.62137}),
                         Formula(conversionString: "Feet to Meters", formula: {$0 / 3.2808}),
                         Formula(conversionString: "Yards to Meters", formula: {$0 / 1.0936}),
                         Formula(conversionString: "Meters to Feet", formula: {$0 * 3.2808}),
                         Formula(conversionString: "Meters to Yards", formula: {$0 * 1.0936}),
                         Formula(conversionString: "Inches to Cm", formula: {$0 / 0.3937}),
                         Formula(conversionString: "Cm to Inches", formula: {$0 * 0.3937}),
                         Formula(conversionString: "Farenheit to Celsuis", formula: {($0 - 32) * (5/9)}),
                         Formula(conversionString: "Celsius to Farenheit", formula: {($0 * (5/9)) + 32}),
                         Formula(conversionString: "Quarts to Liters", formula: {$0 / 1.05669}),
                         Formula(conversionString: "Liters to Quarts", formula: {$0 * 1.05669})]

    
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.dataSource = self
        formulaPicker.delegate = self
        conversionString = formulasArray[formulaPicker.selectedRow(inComponent: 0)].conversionString
        userInput.becomeFirstResponder()
        signSegment.isHidden = true
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func calculateConversion(){        
        guard let inputValue = Double(userInput.text!) else {
            if userInput.text != "" {
                showAlert(title: "Cannot Convert Value", message: "\"\(userInput.text!)\" is not a valid number.")
            }
            return
        }
        
        var outputValue = formulasArray[formulaPicker.selectedRow(inComponent: 0)].formula(inputValue)
        
        let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments - 1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f" : "%f")
        let outputString = String(format: formatString, outputValue)
        
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
        
    }
    
    // MARK: - IBActions
    
    @IBAction func userInputChanged(_ sender: UITextField) {
        resultsLabel.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConversion()
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        calculateConversion()
    }
    
    @IBAction func signSegmentSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0 {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        if userInput.text != "-" {
            calculateConversion()
        }
    }
}


// MARK: - Extension
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulasArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulasArray[row].conversionString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionString = formulasArray[row].conversionString
        
        if conversionString.lowercased().contains("Celsius".lowercased()) || conversionString.lowercased().contains("Farenheit".lowercased()) {
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
            signSegment.selectedSegmentIndex = 0
        }
        
        let unitsArray = formulasArray[row].conversionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        calculateConversion()
    }
    
}
