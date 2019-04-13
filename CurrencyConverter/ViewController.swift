//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Piotr_Brus on 24/03/2019.
//  Copyright © 2019 Piotr_Brus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let url = "https://api.exchangeratesapi.io/latest?base=PLN"
    let currencyArray = ["--","EUR","GBP","USD","AUD", "BRL","CAD","CNY","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","RON","RUB","SEK","SGD","ZAR"]
    var chosen : String = ""
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var switchState: UISwitch!
    @IBAction func switchFunc(_ sender: UISwitch) {
        
        if sender.isOn == true {
            
            currencyLabel.text = "PLN"
            
        } else {
            
            currencyLabel.text = chosen
            
        }
        
    }
    @IBOutlet weak var userValue: UITextField!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBAction func count(_ sender: UIButton) {
        
        request()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosen = currencyArray[row]
        
        if switchState.isOn == false {
            
            currencyLabel.text = chosen
            
        }
        print(chosen)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userValue.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        userValue.resignFirstResponder()
        return(true)
        
    }
    
    func request() {
        
        Alamofire.request(url).responseJSON{(response) in
            if response.result.isSuccess {
                print("Mam dane!")
                print(response)
                
                let currencyJSON : JSON = JSON(response.result.value!)
                
                let result = currencyJSON["rates"][self.chosen].doubleValue
                
                if self.chosen == "--" && self.userValue.text == "" {
                    
                    self.mainLabel.text = "Podaj kwotę i wybierz walutę"
                    
                } else if self.chosen == "--"{
                    
                    self.mainLabel.text = "Wybierz walutę"
                    
                }
                    
                else if self.userValue.text == "" {
                    
                    self.mainLabel.text = "Podaj kwotę"
                    
                }
                
                else if self.switchState.isOn == true {
                    
                    let doubleValue = Double(self.userValue.text!)
                    let labelResult = doubleValue! * result
                    let labelText = String(format: "%.2f", labelResult)
                    self.mainLabel.text = labelText + " " + self.chosen
                    self.currencyLabel.text = "PLN"
                    
                }
                
                else {
                    
                    let doubleValue = Double(self.userValue.text!)
                    let labelResult = doubleValue! / result
                    let labelText = String(format: "%.2f", labelResult)
                    self.mainLabel.text = labelText + " PLN"
                    
                }
                
            }
        }
        
    }


}

