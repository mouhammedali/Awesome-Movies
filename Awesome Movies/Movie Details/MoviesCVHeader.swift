//
//  MoviesCVHeader.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 7/4/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import UIKit
import Cosmos
class MoviesCVHeader: UICollectionReusableView {
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var stackView: UIStackView!
    var loaded = false
    func setupView(movie:MovieModelItem){
        if loaded {
            return
        }
        loaded = true
        addLblWith(text:"●Title: \(movie.title ?? "")", index: 0)
        addLblWith(text:"●Release Year: \(movie.year ?? 0)", index: 1)
        ratingView.rating = movie.rating ?? 0
        if (movie.cast?.count ?? 0) > 0 {
            addLblWith(text:"●Cast:", index: nil)
            for actor in movie.cast ?? [String]() {
                addLblWith(text: "\t-\(actor)", index: nil)
            }
        }
        if (movie.genres?.count ?? 0) > 0 {
            addLblWith(text:"●Genre:", index: nil)
            for genre in movie.genres ?? [String]() {
                addLblWith(text: "\t-\(genre)", index: nil)
            }
        }
//        self.view.updateConstraintsIfNeeded()
    }
    func addLblWith(text:String,index:Int?){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 146, height: 40))
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.textColor = .white
        label.text = text
        label.numberOfLines = 0
        if index != nil {
            stackView.insertArrangedSubview(label, at: index ?? 0)
        }else{
            stackView.addArrangedSubview(label)
        }
        
    }

}
