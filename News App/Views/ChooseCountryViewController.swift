//
//  NewsPreferanceViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/07.
//

import UIKit

class ChoseCountryViewController: UIViewController {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private lazy var viewModel = NewsListViewModel()
    private lazy var rowNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        viewModel.fillCountryNames()
    }
}

extension ChoseCountryViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        rowNumber = indexPath.row
        performSegue(withIdentifier: "goToNews", sender: self)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        viewModel.countryPrefixes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNews" {
            viewModel.changeCountryCode(rowNumber)
            let destinationVC = segue.destination as? NewsViewController
            destinationVC?.countryCode = viewModel.countryCode
            
        }
    }
}
