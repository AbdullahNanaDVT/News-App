//
//  NewsCell.swift
//  News App
//
//  Created by Abdullah Nana on 2021/07/01.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var view: UIView!
    
    private func applyCellStyling() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        newsImageView.layer.cornerRadius = 20
        newsImageView.clipsToBounds = true
        
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 10.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCellStyling()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
