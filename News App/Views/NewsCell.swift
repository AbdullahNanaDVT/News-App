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
    @IBOutlet weak var imageStackView: UIStackView!
    
    private func applyCellStyling() {
        
        newsImageView.layer.cornerRadius = 20
        newsImageView.clipsToBounds = true
        
        imageStackView.backgroundColor = .clear
        imageStackView.layer.shadowColor = UIColor.black.cgColor
        imageStackView.layer.shadowOffset = CGSize(width: 5, height: 5)
        imageStackView.layer.shadowOpacity = 0.98
        imageStackView.layer.shadowRadius = 9.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCellStyling()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
