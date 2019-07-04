//
//  ViewController.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 6/27/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import UIKit
import Hero
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataArray = [MovieModelItem](){
        didSet{
            if tableView == nil {
                return
            }
            self.tableView.reloadData()
        }
    }
    var years = [Int]()
    var filteredDict = [Int:[MovieModelItem]]()
    let search = UISearchController(searchResultsController: nil)
    var sortedArray = [MovieModelItem]()
    var filterring = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hero.isEnabled = true
        setupSearchBar()
        parseJson(fileName: "movies")
    }
    
    
    
    //Helper Functions
    func setupSearchBar(){
        search.searchBar.tintColor = .white
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = search
        } else {
            tableView.tableHeaderView = search.searchBar
        }
    }
    func parseJson(fileName:String){
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let movies = try JSONDecoder().decode(MovieModel.self, from: data)
                
                self.dataArray = movies.movies ?? [MovieModelItem]()
                self.sortedArray = self.dataArray.sorted(by: { ($0.rating ?? 0) > ($1.rating ?? 0) })
                
                
            } catch {
                print(error)
            }
        }
    }
    func searchWithTerm(text:String){
        let filtered = sortedArray.filter({
            $0.title?.range(of: text, options: .caseInsensitive) != nil
        })
        let tempDictionary = Dictionary(grouping: filtered, by: { $0.year ?? 0 }).sorted(by: { $0.0 < $1.0 })
        filteredDict = Dictionary(uniqueKeysWithValues: tempDictionary)
        years = Array(filteredDict.keys).sorted()
        filterring = true
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchWithTerm(text:text)
        }
        else {
            filterring = false
            filteredDict = [Int:[MovieModelItem]]()
            years = [Int]()
        }
        self.tableView.reloadData()
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search.searchBar.resignFirstResponder()
        search.dismiss(animated: false, completion: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
        if filterring {
            vc.movie = filteredDict[years[indexPath.section]]?[indexPath.row] ?? MovieModelItem()
        }else{
            vc.movie = dataArray[indexPath.row]
        }
        vc.heroIndex = "\(indexPath.section)-\(indexPath.row)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell {
            cell.selectionStyle = .none
            if filterring {
                cell.setup(item: filteredDict[years[indexPath.section]]?[indexPath.row] ?? MovieModelItem(),heroIndex:"\(indexPath.section)-\(indexPath.row)")
                return cell
            }
            cell.setup(item: dataArray[indexPath.row],heroIndex:"\(indexPath.section)-\(indexPath.row)")
            
            return cell
            
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if filterring {
            return years.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterring {
            if (filteredDict[years[section]]?.count ?? 0) > 5 {
                return 5
            }
            return filteredDict[years[section]]?.count ?? 0
        }
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if filterring {
            return 30.0
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if filterring {
            return "\(years[section])"
        }
        return ""
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont.systemFont(ofSize: 24.0)
            header.textLabel!.textColor = UIColor.orange
        }
    }
    
}
