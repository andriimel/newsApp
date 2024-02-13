//
//  NewsAppCell.swift
//  NewsApp
//
//  Created by Andrii Melnyk on 1/26/24.
//

import UIKit

class NewsAppCell: UITableViewCell {

    var newsManager = NewsManager()
    
    var scienceCell:ScienceNewsViewController?
    var sportCell: SportNewsViewController?
    var healthCell: HealthViewController?
    var entertainmentCell: EntertainmentViewController?
    var favoriteCell: FavoriteViewController?
    
    
    static let identifier = "NewsAppCell"
    
    var cellIsLike = false
    
     let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
         imageView.backgroundColor = .systemBlue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
   
     let newsTitleLabel: UILabel = {
        let label = UILabel()
        // label.backgroundColor = UIColor.red
         label.textColor = .darkGray
         label.textAlignment = .left
         label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    let newsSourceNameLabel: UILabel = {
       let label = UILabel()
       // label.backgroundColor = UIColor.green
        label.textColor = .darkGray
        label.textAlignment = .center
       label.font = .systemFont(ofSize: 15, weight: .semibold)
       return label
   }()
    let newsDateLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = UIColor.blue
        label.textAlignment = .center
       label.font = .systemFont(ofSize: 10, weight: .semibold)
       return label
   }()
   
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
      
        button.tintColor = .red
        
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(logoImageView)
        self.contentView.addSubview(newsTitleLabel)
        self.contentView.addSubview(newsSourceNameLabel)
        accessoryView = likeButton
        
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
       // self.addSubview(newsDateLabel)

    }
    required init?(coder: NSCoder) {
        fatalError("error with cell implementation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        logoImageView.frame = CGRect(x: 10,
                                     y: 5,
                                     width: 70,
                                     height: 70)


        newsSourceNameLabel.frame = CGRect(x: logoImageView.frame.maxX+10,
                                       y: 0,
                                       width: contentView.frame.width - logoImageView.frame.width - (accessoryView?.frame.width)!,
                                           height: contentView.frame.height * 0.3)
        newsTitleLabel.frame = CGRect(x: logoImageView.frame.maxX + 10,
                                      y: newsSourceNameLabel.frame.height,
                                      width: contentView.frame.width - logoImageView.frame.width - (accessoryView?.frame.width)!,
                                      height: contentView.frame.height - newsSourceNameLabel.frame.height)
        accessoryView?.frame = CGRect(x: newsTitleLabel.frame.maxX + 10,
                                      y: 20,
                                      width: 40,
                                      height: 40)
        
    }
    
    func load(news: News) {
       
        newsTitleLabel.text = news.titleName
        newsSourceNameLabel.text = news.newsSourceName
        self.accessoryView?.tintColor = news.isLike ? UIColor.red : .lightGray
        
        let url = URL(string: news.imageUrl ?? "")
        logoImageView.sd_setImage(with: url)
    }

 @objc func likeButtonPressed(sender: UIButton) {
     
     scienceCell?.sportLikeNewsButtonPressed(cell: self )
     sportCell?.sportLikeNewsButtonPressed(cell: self)
     healthCell?.healthLikeNewsButtonPressed(cell: self)
     entertainmentCell?.entertainmentLikeNewsButtonPressed(cell: self)
     favoriteCell?.deleteNewsFormList(cell: self)
     
 }
}

