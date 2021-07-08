//
//  NewsPreferanceViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/07.
//

import UIKit

class NewsPreferanceViewController: UIViewController {
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private let countryArray = ["ae","ar","at","au","be","bg","br","ca","ch","cn",
                         "co","cu","cz","de","eg","fr","gb","gr","hk","hu",
                         "id","ie","il","in","it","jp","kr","lt","lv","ma",
                         "mx","my","ng","nl","no","nz","ph","pl","pt","ro",
                         "rs","ru","sa","se","sg","si","sk","th","tr","tw",
                         "ua","us","ve","za"]
    
    private let countryNameArray = ["United Arab Emirates", "Argentina", "Austria", "Australia", "Belgium", "Bulgaria",
                            "Brazil", "Canada", "Switzerland", "China",
                            "Colombia", "Cuba", "Czech Republic", "Germany", "Egyp", "France" ,"Great Britain",
                            "Greece", "Honk Kong", "Hungary",
                            "Indonesia", "Ireland", "India", "Italy", "Japan" , "South Korea",
                            "Lithuania", "Latvia", "Marocco",
                            "Mexico", "Malaysia", "Nigeria", "Netherlands", "Norway", "New Zealand", "Philippines",
                            "Poland", "Portugal", "Romania",
                            "Serbia", "Russia", "Saudi Arabia" , "Sweden", "Singapore", "Slovenia", "Slovakia",
                            "Thailand", "Turkey", "Taiwan",
                            "Ukraine", "USA", "Venezuela", "South Africa"]
    
    private var rowNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        button.layer.cornerRadius = 10
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNews", sender: self)
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
          rowNumber = row + 1
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNews" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.countryCode = countryArray[rowNumber]
        }
    }
}
