//
//  KWDropdownMenu.swift
//  KWDropdownMenu
//  自定义下拉展示选项视图
//  Created by wangk on 17/1/10.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class KWDropdownBaseItem:NSObject {
    var title:String = ""
    var selected = false
    convenience init(title:String, selected:Bool = false) {
        self.init()
        
        self.selected = selected
        self.title = title
    }
}

class KWDropdownCollectionView: UICollectionView,UICollectionViewDelegate, UICollectionViewDataSource {
    // 数据源
    var datasource:[KWDropdownBaseItem]!
    // 自定义的cell样式
    var collectionViewClass:AnyClass!
    // 自定义cell的宽度
    var itemWidth:CGFloat!
    // 自定义cell的高度
    var itemHeigh:CGFloat!
    // 点击回调
    var clickClosure:(item:KWDropdownBaseItem, indexPath:NSIndexPath)->Void = {_ in }
    
    convenience init(itemWidth:CGFloat,
                     height:CGFloat,
                     minimumLineSpacing:CGFloat,
                     minimumInteritemSpacing:CGFloat,
                     collectionViewClass:AnyClass,
                     datasource:[KWDropdownBaseItem]) {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: height)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.minimumLineSpacing = minimumLineSpacing//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing//每个相邻layout的左右
        flowLayout.headerReferenceSize = CGSizeMake(0,0)
        flowLayout.sectionInset = UIEdgeInsetsMake(kDropdwonMenuCollectionViewTopBottomInset, kDropdwonMenuCollectionViewLeftRightInset, kDropdwonMenuCollectionViewTopBottomInset, kDropdwonMenuCollectionViewLeftRightInset)
        
        self.init(frame: CGRectZero, collectionViewLayout: flowLayout)
        self.datasource = datasource
        
        self.scrollEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        self.delegate = self
        self.dataSource = self
        self.registerClass(collectionViewClass, forCellWithReuseIdentifier: "cell")
        
        self.itemWidth = itemWidth
        self.itemHeigh = height
    }
    
    // MARK: -Public
    
    // MARK: -CollectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func collectionViewContentSize() -> CGSize {
        return CGSize(width: 50, height: 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = self.datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! KWDropdownBaseCollectionViewCell
        cell.update(item)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = self.datasource[indexPath.row]
        self.clickClosure(item: item, indexPath: indexPath)
    }
}
