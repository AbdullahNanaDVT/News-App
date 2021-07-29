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
    private var rowNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        viewModel.fillCountryNames()
    }
}

extension NewsPreferanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfCountries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell")!
        cell.backgroundColor = .clear
        cell.textLabel?.text = viewModel.getCountryNames()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowNumber = indexPath.row
        performSegue(withIdentifier: "goToNews", sender: self)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        viewModel.getCountryPrefixes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNews" {
            viewModel.setCountryCode(rowNumber)
            let destinationVC = segue.destination as? ViewController
            destinationVC?.countryCode = viewModel.getCountryCode()
            
        }
    }
}
