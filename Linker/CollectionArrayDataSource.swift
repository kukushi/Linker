//
//  CollectionArrayDataSource.swift
//  BurstLinker
//
//  Created by kukushi on 12/18/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import UIKit

class CollectionArrayDataSource: NSObject, UICollectionViewDataSource {
    typealias ConfigureCollectionCellBlock = (cell: UICollectionViewCell, item: AnyObject) -> Void
    
    var items: [AnyObject]!
    var cellIdentifier: String!
    var configureBlock: ConfigureCollectionCellBlock!
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier!, forIndexPath: indexPath) as UICollectionViewCell
        let item: AnyObject = items[indexPath.row]
        if configureBlock != nil {
            configureBlock(cell: cell, item: item)
        }
        return cell
    }
}


class TableArrayDataSource: NSObject, UITableViewDataSource {
    typealias ConfigureTableCellBlock = (cell: UITableViewCell, item: AnyObject) -> Void
    var items: [AnyObject]!
    var cellIdentifier: String!
    var configureBlock: ConfigureTableCellBlock!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let item: AnyObject = items[indexPath.row]
        if configureBlock != nil {
            configureBlock(cell: cell, item: item)
        }
        return cell
    }
}