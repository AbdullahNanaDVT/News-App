//
//  ViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//

import UIKit
import SafariServices
import SDWebImage

class ViewController: UITableViewController, NewsManagerDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chooseCountryButton: UIBarButtonItem!
    
    internal var countryCode = NSLocale.current.regionCode?.lowercased()
    private var viewModel = NewsListViewModel()
    private let newManager = NewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        validateCountryCode()
        updateNews(countryCode: countryCode!)
        applyStyling()
        refreshScreen()
    }

    @IBAction func didPressChooseCountryButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToPreferance", sender: self)
    }

    private func refreshScreen() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        updateNews()
        self.tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func applyStyling() {
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "barColor")
        tableView.backgroundColor = .clear
        searchBar.backgroundColor = .clear
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background")!)
        searchBar.backgroundColor = .clear
    }
    
    private func validateCountryCode() {
        if countryCode == nil {
            countryCode = "za"
        }
    }

    internal func updateNews(searchString: String = "", countryCode: String = "") {
        viewModel.loadNewsData(searchString: searchString, countryCode: countryCode) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    internal func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsCell
        let newsObject = viewModel.newsArray[indexPath.row]
        cell?.titleLabel.text = newsObject.title
        cell?.descriptionLabel.text = newsObject.description
        cell?.newsImageView.sd_setImage(with: URL(string: newsObject.urlToImage), placeholderImage: UIImage(named: "news.jpg"))
        cell?.backgroundColor = .clear
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        searchBar.backgroundColor = .clear
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.newsArray[indexPath.row]
        
        guard let url = URL(string: news.url ) else {
            return
        }

        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .overFullScreen
        present(safariViewController, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let title = searchBar.text {
            updateNews(searchString: title)
            checkResults()
        }
        searchBar.text = ""
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            return true
        } else {
            searchBar.placeholder = "Please type something"
            return false
        }
    }

    private func checkResults() {
        if newManager.totalResults == 0 {
            let alert = UIAlertController(title: "No Results", message: "No articles matches your search. Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            tableView.reloadData()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if let title = searchBar.text {
            updateNews(searchString: title)
            checkResults()
        }
        searchBar.text = ""
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            updateNews(searchString: searchText)
            checkResults()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}




