//
//  BangumiSearchViewController.swift
//  Linker
//
//  Created by kukushi on 12/19/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import UIKit

class BangumiSearchViewController: UIViewController {

    lazy var dataSource = TableArrayDataSource()
    let originalItems = ["1", "2", "3"]
//    @IBOutlet var searchDisplayController: UISearchDisplayController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.items = ["1", "2", "3"]
        dataSource.cellIdentifier = "BilibiliSearchCell"
        dataSource.configureBlock = { (cell, item) -> Void in
            let theCell = cell as UITableViewCell
            theCell.textLabel?.text = item as? String
        }
        searchDisplayController?.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BilibiliSearchCell")
        searchDisplayController?.searchResultsDataSource = dataSource
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BangumiSearchViewController: UISearchDisplayDelegate, UISearchBarDelegate {
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        return false
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        return false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let stringToSearch = searchBar.text
        dataSource.items = originalItems.filter({
            $0.rangeOfString(stringToSearch) != nil
        })
    }
}

