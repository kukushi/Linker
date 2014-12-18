//
//  CollectionArrayDataSource.swift
//  BurstLinker
//
//  Created by kukushi on 12/18/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import UIKit

class CollectionArrayDataSource: NSObject, UICollectionViewDataSource {
    typealias ConfigureCellBlock = (cell: UICollectionViewCell, item: AnyObject) -> Void
    
    var items: [AnyObject]!
    var cellIdentifier: String!
    var configureBlock: ConfigureCellBlock!
   
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
