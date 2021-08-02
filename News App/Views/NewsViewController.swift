//
//  ViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//
import UIKit
import SafariServices
import SDWebImage

class NewsViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chooseCountryButton: UIBarButtonItem!
    
    private let viewModel = NewsListViewModel()
    private let newsManager = NewsManager()
    lazy var countryCode = NSLocale.current.regionCode?.lowercased()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyling()
        refreshScreen()
        updateNews(countryCode: countryCode ?? "za")
        
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
        navigationController?.navigationBar.barTintColor = UIColor(named: "barColor")
        tableView.backgroundColor = .clear
        searchBar.backgroundColor = .clear
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background")!)
        searchBar.backgroundColor = .clear
    }

    private func updateNews(searchString: String = "", countryCode: String = "") {
        viewModel.loadNewsData(searchString: searchString, countryCode: countryCode) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    internal func didFailWithError(error: Error) {
        print(error)
    }
    
    internal func showAlert() {
        if viewModel.numberOfNewsResults == 0 {
            let alert = UIAlertController(title: "No Results",
                                          message: "No articles matches your search. Please try again.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension NewsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfNewsResults
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsCell
        let newsObject = viewModel.newsResults[indexPath.row]
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
        let news = viewModel.newsResults[indexPath.row]
        
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