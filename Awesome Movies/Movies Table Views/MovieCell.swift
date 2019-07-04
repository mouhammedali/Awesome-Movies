//
//  MovieCell.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 6/29/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import UIKit
import Cosmos
class MovieCell: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(item: MovieModelItem,heroIndex:String) {
        titleLabel.text = item.title ?? ""
        titleLabel.hero.id = heroIndex + "-title"
        ratingView.rating = item.rating ?? 0
        ratingView.hero.id = heroIndex + "-rateView"
    }

}
