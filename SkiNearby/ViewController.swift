//
//  ViewController.swift
//
//  Created by Nelma Perera.
//  Copyright © 2016 Nelma Perera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SkiAreaDataProtocol, UITextFieldDelegate {
    
    let areaData = SkiAreaData()
    
    @IBOutlet weak var getZipCodeText: UITextField!
    
    @IBOutlet weak var areaNameLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getZipCodeText.delegate = self
        self.messageLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getAreaDataButton(sender: AnyObject) {
        if self.getZipCodeText.text! == "" {
            self.responseError("Zip Code text field cannot be empty")
            return
        }
        if self.getZipCodeText.text!.characters.count < 5 {
            self.responseError("Zip Code text field must have at least 5 characters")
            return
        }
        self.areaNameLabel.text! = "<area-name>"
        self.countryLabel.text! = "<country>"
        self.regionLabel.text! = "<region>"
        self.messageLabel.hidden = true
        
        self.areaData.delegate = self
        self.areaData.getData(self.getZipCodeText.text!)
    }
    
    func responseDataHandler(data: NSDictionary) {
        dispatch_async(dispatch_get_main_queue()) {
            self.messageLabel.hidden = true
        
            self.areaNameLabel.text! = self.getValue(data, nestedKey: "areaName")
        
            self.countryLabel.text! = self.getValue(data, nestedKey: "country")
        
            self.regionLabel.text! = self.getValue(data, nestedKey: "region")
        }
    }
    
    func responseError(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.messageLabel.text! = message
            self.messageLabel.hidden = false
        }
    }
    
    func getValue(data: NSDictionary, nestedKey: String) -> String{
        if let data_ = data["data"]!["nearest_area"]!![0][nestedKey]!![0]["value"]!!.description {
            return data_
        }
        return ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

