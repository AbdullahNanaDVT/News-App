//
//  NewsPreferanceViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/07.
//

import UIKit

class NewsPreferanceViewController: UIViewController {
    
    @IBOutlet private weak var countryPicker: UIPickerView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    private var countryNamePropertyListArray: NSArray? = nil
    private var countryCodePropertyListArray: NSArray? = nil
    private var countryNameArray: [String] = []
    private var countryCodeArray: [String] = []
    
    private var rowNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        countryPicker.dataSource = self
        countryPicker.delegate = self
        fillCountryNames()
        button.layer.cornerRadius = 10
    }
    
    @IBAction private func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNews", sender: self)
    }
    
    private func fillCountryNames() {
        if let countryNamePath = Bundle.main.path(forResource: "Countries", ofType: "plist"),
           let countryCodePath = Bundle.main.path(forResource: "CountryCodes", ofType: "plist"){
            countryNamePropertyListArray = NSArray(contentsOfFile: countryNamePath)
            countryCodePropertyListArray = NSArray(contentsOfFile: countryCodePath)
            countryNameArray = countryNamePropertyListArray as! [String]
            countryCodeArray = countryCodePropertyListArray as! [String]
        }
    }
}

//MARK: - UIPickerView DataSource & Delegate
extension NewsPreferanceViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }

      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return countryNameArray.count
      }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryNameArray[row]
      }

      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          rowNumber = row
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNews" {
            let _ = segue.destination as! ViewController
        }
    }
}
