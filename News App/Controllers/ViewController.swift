//
//  ViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//

import UIKit
import SafariServices
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchLabel: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    private var newsArray = [NewsData]()
    
    internal var countryCode = "za"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getNews()
        
        applyStyling()
        
        refreshScreen()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchLabel.endEditing(true)
        if let title = searchLabel.text {
            getNews(searchFor: title)
        }
        searchLabel.text = ""
        refreshScreen()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goBackToPreferance", sender: self)
    }
    
    private func refreshScreen() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        getNews()
    }
    
    private func applyStyling() {
        tableView.backgroundColor = .clear
    }
    
    private func getNews(searchFor searchString: String = "") {
        
        self.newsArray.removeAll()
        self.tableView.reloadData()
        
        let baseUrlString = "https://newsapi.org/v2/"
        let topHeadline = "top-headlines?"
        
        var urlString = ""
        
        if searchString == "" {
            urlString = "\(baseUrlString)\(topHeadline)country=\(countryCode)&apiKey=\(APIKey.key)"
        } else {
            urlString = "\(baseUrlString)\(topHeadline)q=\(searchString)&apiKey=\(APIKey.key)"
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Could not retrieve URL")
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                guard let news = try? JSONDecoder().decode(NewsResults.self, from: data) else {
                    fatalError("Error decoding data \(error!)")
                }
                let articles = news.articles
                self?.newsArray = articles
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newsObject = newsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell

        cell.titleLabel.text = newsObject.title
        cell.descriptionLabel.text = newsObject.description
        cell.newsImageView.sd_setImage(with: URL(string: newsObject.urlToImage ?? ""), placeholderImage: UIImage(named: "news.jpg"))
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsArray[indexPath.row]
        
        guard let url = URL(string: news.url ?? "") else {
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .overFullScreen
        present(safariViewController, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchLabel.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let title = searchLabel.text {
            getNews(searchFor: title)
        }
        searchLabel.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please type something"
            return false
        }
    }
}

