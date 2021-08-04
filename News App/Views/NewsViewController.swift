//
//  ViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//
import UIKit
import SafariServices
import SDWebImage
import MapKit
import CoreLocation

class NewsViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chooseCountryButton: UIBarButtonItem!
    private let newsViewModel = NewsViewModel()
    private var chooseCountryVC = ChooseCountryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseCountryVC.delegate = self
        newsViewModel.delegate = self
        applyStyling()
        refreshScreen()
        
        newsViewModel.locationSetup()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func didPressChooseCountryButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToPreferance", sender: self)
    }
    
    @objc private func didPullToRefresh() {
        updateNews()
        self.tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    private func refreshScreen() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func applyStyling() {
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.barTintColor = .barColor
        tableView.backgroundColor = .clear
        searchBar.backgroundColor = .clear
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background")!)
        searchBar.backgroundColor = .clear
    }

    private func updateNews(searchString: String = "", countryCode: String = "") {
        newsViewModel.mapNewsData(searchString: searchString, countryCode: countryCode) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    internal func didFailWithError(error: Error) {
        print(error)
    }
    
    internal func showAlert() {
        if newsViewModel.numberOfNewsResults == 0 {
            let alert = UIAlertController(title: NSLocalizedString("ALERT_TITLE", comment: ""),
                                          message: NSLocalizedString("ALERT_MESSAGE", comment: ""),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_ACTION_TITLE", comment: ""), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension NewsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsViewModel.numberOfNewsResults
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsCell
        let newsObject = newsViewModel.newsResults[indexPath.row]
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
        let news = newsViewModel.newsResults[indexPath.row]
        
        guard let url = URL(string: news.url ) else {
            return
        }

        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .overFullScreen
        present(safariViewController, animated: true)
    }
}

extension NewsViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let title = searchBar.text {
            updateNews(searchString: title)
            showAlert()
        }
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let title = searchBar.text {
            updateNews(searchString: title)
            showAlert()
        }
        searchBar.text = ""
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        tableView.reloadData()
    }
}

extension NewsViewController: ChooseCountryDelegate {
    func didChangeCountry(to code: String) {
        let countryCode = newsViewModel.countryCode(for: code)
        print("VC countryCode result: \(newsViewModel.countryCode(for: code))")
        print("didChangeCountry delegate : \(code)")
        DispatchQueue.main.async {
            self.updateNews(countryCode: countryCode)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPreferance" {
            let secondVC = segue.destination as? ChooseCountryViewController
            secondVC?.delegate = self
        }
    }
}
