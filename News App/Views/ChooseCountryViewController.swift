//
//  NewsPreferanceViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/07.
//

import UIKit

protocol ChooseCountryDelegate: AnyObject {
    func didChangeCountry(to _: String)
}

class ChooseCountryViewController: UIViewController {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private lazy var viewModel = ChooseCountryViewModel()
    private lazy var rowNumber: Int = 0
    weak var delegate: ChooseCountryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        viewModel.fillCountryNames()
    }
}

extension ChooseCountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCountries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell")!
        cell.backgroundColor = .clear
        cell.textLabel?.text = viewModel.countryNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newCountryCode = viewModel.convertToCountryCode(indexPath.row)
        delegate?.didChangeCountry(to: newCountryCode)
        dismiss(animated: true, completion: nil)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        viewModel.countryPrefixes
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        index
    }
}
