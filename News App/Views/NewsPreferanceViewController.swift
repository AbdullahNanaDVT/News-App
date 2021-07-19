//
//  NewsPreferanceViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/07.
//

import UIKit

class NewsPreferanceViewController: UIViewController {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = NewsListViewModel()
    private var countryNamePropertyListArray: NSArray?
    private var countryCodePropertyListArray: NSArray?
    private var countryNameArray: [String] = []
    private var countryCodeArray: [String] = []
    private var countryLetterArray: [String] = []
    private var rowNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        fillCountryNames()
    }
    
    private func fillCountryNames() {
        if let countryNamePath = Bundle.main.path(forResource: "Countries", ofType: "plist"),
           let countryCodePath = Bundle.main.path(forResource: "CountryCodes", ofType: "plist") {
            countryNamePropertyListArray = NSArray(contentsOfFile: countryNamePath)
            countryCodePropertyListArray = NSArray(contentsOfFile: countryCodePath)
            countryNameArray = countryNamePropertyListArray as? [String] ?? []
            countryCodeArray = countryCodePropertyListArray as? [String] ?? []
            countryNameArray = countryNameArray.sorted()
            countryCodeArray = countryCodeArray.sorted()
            
            for country in countryNameArray {
                let countryLetter = String(country.prefix(1))
                countryLetterArray.append(countryLetter)
            }
        }
    }
}

extension NewsPreferanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell")!
        cell.backgroundColor = .clear
        cell.textLabel?.text = countryNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowNumber = indexPath.row
        performSegue(withIdentifier: "goToNews", sender: self)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return countryLetterArray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNews" {
            let destinationVC = segue.destination as? ViewController
            destinationVC?.countryCode = countryCodeArray[rowNumber]
        }
    }
}
