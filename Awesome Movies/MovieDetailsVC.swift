//
//  MovieDetailsVC.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 6/30/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import UIKit
import Imaginary
import Lightbox
import Cosmos
class MovieDetailsVC: UIViewController {
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieYearLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var stackView: UIStackView!
    var flickerHelper:FlickrApiHelper?
    @IBOutlet weak var photosCollectionView: UICollectionView!
    var heroIndex = ""
    var movie = MovieModelItem(){
        didSet {
            flickerHelper = FlickrApiHelper(title:self.movie.title ?? "")
            flickerHelper?.getImages(completionhandler: { (resCode) in
                self.photosCollectionView.reloadData()
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStackView()
        setupHero()
        photosCollectionView.accessibilityIdentifier = "PhotosCollctionView"
    }
    func setupHero(){
        self.hero.isEnabled = true
        movieTitleLbl.hero.id = heroIndex + "-title"
        ratingView.hero.id = heroIndex + "-rateView"
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    func updateStackView(){
        movieTitleLbl.text = "●Title: \(movie.title ?? "")"
        movieYearLbl.text = "●Release Year: \(movie.year ?? 0)"
        ratingView.rating = movie.rating ?? 0
        if (movie.cast?.count ?? 0) > 0 {
            addLblWith(text:"●Cast:")
            for actor in movie.cast ?? [String]() {
                addLblWith(text: "\t-\(actor)")
            }
        }
        if (movie.genres?.count ?? 0) > 0 {
            addLblWith(text:"●Genre:")
            for genre in movie.genres ?? [String]() {
                addLblWith(text: "\t-\(genre)")
            }
        }
        self.view.updateConstraintsIfNeeded()
    }
    func addLblWith(text:String){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 146, height: 20))
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.textColor = .white
        label.text = text
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
    }
}
extension MovieDetailsVC:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= (flickerHelper?.flickrPhotos.photo?.count ?? 0) {
            return
        }
        presentImageAt(index:indexPath.row)
    }
    func presentImageAt(index:Int){
        let item = flickerHelper?.flickrPhotos.photo?[index] ?? photoItem()
        guard let imageUrl = URL(string: item.getPhoto()) else { return}
        let lightImage = [LightboxImage(imageURL:imageUrl)]
        let controller = LightboxController(images: lightImage)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
        controller.goTo(index, animated: false)
    }
}
extension MovieDetailsVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if flickerHelper?.isNext ?? true {
            return (flickerHelper?.flickrPhotos.photo?.count ?? 0) + 1
        }
        print(flickerHelper?.flickrPhotos.photo?.count ?? 0)
        return flickerHelper?.flickrPhotos.photo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= (flickerHelper?.flickrPhotos.photo?.count ?? 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)
            cell.accessibilityIdentifier = "PhotoCell_\(indexPath.row)"
            let activityIndicator = cell.viewWithTag(1) as! UIActivityIndicatorView
            activityIndicator.startAnimating()
            flickerHelper?.getImages(completionhandler: { (resCode) in
                collectionView.reloadData()
            })
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        cell.accessibilityIdentifier = "PhotoCell_\(indexPath.row)"
        let imgView = cell.viewWithTag(1) as! UIImageView
        let item = flickerHelper?.flickrPhotos.photo?[indexPath.row] ?? photoItem()
        guard let imageUrl = URL(string: item.getPhoto()) else { return cell }
        imgView.setImage(url: imageUrl, placeholder: UIImage(named:"vide"))
        return cell
    }
    
    
}
