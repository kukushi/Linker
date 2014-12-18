//
//  AddLinkViewController.swift
//  BurstLinker
//
//  Created by kukushi on 12/17/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import UIKit

class AddLinkViewController: UIViewController {
    
    @IBOutlet weak var itemCollection: UICollectionView!
    
    var dataSource: CollectionArrayDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = CollectionArrayDataSource()
        dataSource.items = ["Bilibili"]
        dataSource.cellIdentifier = "LinkCell"
        dataSource.configureBlock = { (cell, item) -> Void in
            let linkCell = cell as LinkCollectionCell
            let text = item as String
            linkCell.textLabel.text = text
        }
        
        itemCollection.dataSource = dataSource

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
