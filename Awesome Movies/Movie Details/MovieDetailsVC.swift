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
        setupHero()
    }
    func setupHero(){
        self.hero.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
            let activityIndicator = cell.viewWithTag(1) as! UIActivityIndicatorView
            activityIndicator.startAnimating()
            flickerHelper?.getImages(completionhandler: { (resCode) in
                collectionView.reloadData()
            })
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        let imgView = cell.viewWithTag(1) as! UIImageView
        let item = flickerHelper?.flickrPhotos.photo?[indexPath.row] ?? photoItem()
        guard let imageUrl = URL(string: item.getPhoto()) else { return cell }
        imgView.setImage(url: imageUrl, placeholder: UIImage(named:"vide"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "MoviesCVHeader",
                for: indexPath) as? MoviesCVHeader
                else {
                    return UIView() as! UICollectionReusableView
            }
            headerView.setupView(movie: movie)
            return headerView
        }
        return UICollectionReusableView()
    }
    
}
extension MovieDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // ofSize should be the same size of the headerView's label size:
        let numberOfElements = 3 + (movie.cast?.count ?? 0) + (movie.genres?.count ?? 0)
        let height = 40*numberOfElements
        return CGSize(width: collectionView.frame.size.width, height: CGFloat(height))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.width/2.0
        
        return CGSize(width: size-5, height: size-5)
    }
}

