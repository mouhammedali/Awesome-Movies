//
//  ViewController.swift
//  Awesome Movies
//
//  Created by Mouhammed Ali on 6/27/19.
//  Copyright © 2019 Mouhammed Ali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataArray = [MovieModelItem](){
        didSet{
            tableView.reloadData()
        }
    }
    var years = [Int]()
    var dict = [Int:[MovieModelItem]]()
    let search = UISearchController(searchResultsController: nil)
    var filtered = [MovieModelItem]()
    var sortedArray = [MovieModelItem]()
    var filterring = false
    override func viewDidLoad() {
        super.viewDidLoad()
        search.searchBar.tintColor = .white
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = search
        } else {
            tableView.tableHeaderView = search.searchBar
        }
        parseJson()
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = sortedArray.filter({
                $0.title?.range(of: text, options: .caseInsensitive) != nil
            })
            let tempDictionary = Dictionary(grouping: filtered, by: { $0.year ?? 0 }).sorted(by: { $0.0 < $1.0 })
            dict = Dictionary(uniqueKeysWithValues: tempDictionary)
            years = Array(dict.keys).sorted()
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [MovieModelItem]()
        }
        self.tableView.reloadData()
    }
    func parseJson(){
        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let movies = try JSONDecoder().decode(MovieModel.self, from: data)
                dataArray = movies.movies ?? [MovieModelItem]()
                sortedArray = dataArray.sorted(by: { ($0.rating ?? 0) > ($1.rating ?? 0) })
            } catch {
                print(error)
            }
        }
    }
}
extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell {
            if filterring {
                cell.setup(item: dict[years[indexPath.section]]?[indexPath.row] ?? MovieModelItem())
                return cell
            }
            cell.setup(item: dataArray[indexPath.row])
            
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
            if (dict[years[section]]?.count ?? 0) > 5 {
                return 5
            }
            return dict[years[section]]?.count ?? 0
        }
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if filterring {
            return 30.0
        }
        return 0
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
