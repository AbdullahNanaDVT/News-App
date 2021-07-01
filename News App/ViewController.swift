//
//  ViewController.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    
    //var newsManager = NewsManager()
    
    var newsArray = [NewsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        getNews()
        //print(newsArray)
        //newsManager.fetchNews()
        //self.tableView.rowHeight = 250
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    func getNews() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=sa&category=business&apiKey=c48088d2c6704e9692a00e6de346f105") else {
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
        //print(newsObject)


        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell

        cell.titleLabel.text = newsObject.title
        cell.authorLabel.text = newsObject.author
        cell.descriptionLabel.text = newsObject.description
        cell.urlLabel.text = newsObject.url
        cell.urlToImageLabel.text = newsObject.urlToImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let news = newsArray[indexPath.row]
        print(news)
        guard let url = URL(string: news.url ?? "") else {
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .fullScreen
        present(safariViewController, animated: true)
    }
}

//extension ViewController: NewsManagerDelegate {
//    func didUpdateNews(_ newsManager: NewsManager, news: NewsModel) {
//
//        let newsCell = NewsCell()
//        DispatchQueue.main.async {
//            newsCell.titleLabel.text = news.title
//            newsCell.authorLabel.text = news.author
//            newsCell.descriptionLabel.text = news.description
//            newsCell.urlLabel.text = news.url
//            newsCell.urlToImageLabel.text = news.urlToImage
//        }
//        tableView.reloadData()
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//}
