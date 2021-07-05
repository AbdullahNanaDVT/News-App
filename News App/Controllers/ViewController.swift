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
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var topHeadlinesLabel: UILabel!
    
    var newsArray = [NewsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getNews()
        
        applyLabelStyling()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    fileprivate func applyLabelStyling() {
        newsLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        topHeadlinesLabel.font = topHeadlinesLabel.font.withSize(32)
        topHeadlinesLabel.textColor = .gray
    }
    
    func getNews() {
        let baseUrlString = "https://newsapi.org/v2/"
        let topHeadline = "top-headlines?country=sa"
        
        let urlString = "\(baseUrlString)\(topHeadline)&apiKey=\(APIKey.key)"
        guard let url = URL(string: urlString) else {
            fatalError("URL guard stmt failed")
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            //HANDLE DECODING HERE
            if let data = data {
                guard let news = try? JSONDecoder().decode(NewsResults.self, from: data) else {
                    fatalError("Error decoding data \(error!)")
                }
                let articles = news.articles
                self?.newsArray = articles
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
        cell.authorLabel.text = newsObject.author
        cell.descriptionLabel.text = newsObject.description
        cell.newsImageView.sd_setImage(with: URL(string: newsObject.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsArray[indexPath.row]
        
        guard let url = URL(string: news.url ?? "") else {
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .fullScreen
        present(safariViewController, animated: true)
    }
}
