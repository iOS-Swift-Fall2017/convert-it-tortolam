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
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    
    var formulasArray = ["Miles to Kilometers",
                         "Kilometers to Miles",
                         "Feet to Meters",
                         "Yards to Meters",
                         "Meters to Feet",
                         "Meters to Yards"]
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.dataSource = self
        formulaPicker.delegate = self
    }

    func calculateConversion(){        
        guard let inputValue = Double(userInput.text!) else {
            print("Show alert here")
            return
        }
        
        var outputValue = 0.0
        
        switch conversionString {
        case "Miles to Kilometers":
            outputValue = inputValue / 0.62137
        case "Kilometers to Miles":
            outputValue = inputValue * 0.62137
        case "Feet to Meters":
            outputValue = inputValue / 3.2808
        case "Yards to Meters":
            outputValue = inputValue / 1.0936
        case "Meters to Feet":
            outputValue = inputValue * 3.2808
        case "Meters to Yards":
            outputValue = inputValue * 1.0936
        default:
            print("Show alert idk")
        }
        
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputValue) \(toUnits)"
        
    }
    
    // MARK: - Actions
    @IBAction func convertButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
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
        return formulasArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionString = formulasArray[row]
        let unitsArray = formulasArray[row].components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        calculateConversion()
    }
    
}
