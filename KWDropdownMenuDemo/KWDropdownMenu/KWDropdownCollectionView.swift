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
    var clickClosure:(_ item:KWDropdownBaseItem, _ indexPath:IndexPath)->Void = {_ in }
    var didNeedHighlightItemClosure:(_ indexPath:IndexPath)->Void = {_ in }
    
    convenience init(itemWidth:CGFloat,
                     height:CGFloat,
                     minimumLineSpacing:CGFloat,
                     minimumInteritemSpacing:CGFloat,
                     collectionViewClass:AnyClass,
                     datasource:[KWDropdownBaseItem]) {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: height)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.minimumLineSpacing = minimumLineSpacing//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing//每个相邻layout的左右
        flowLayout.headerReferenceSize = CGSize(width: 0,height: 0)
        flowLayout.sectionInset = UIEdgeInsetsMake(kDropdwonMenuCollectionViewTopBottomInset, kDropdwonMenuCollectionViewLeftRightInset, kDropdwonMenuCollectionViewTopBottomInset, kDropdwonMenuCollectionViewLeftRightInset)
        
        self.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.datasource = datasource
        
        self.isScrollEnabled = false
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.register(collectionViewClass, forCellWithReuseIdentifier: "cell")
        
        self.itemWidth = itemWidth
        self.itemHeigh = height
    }
    
    // MARK: -Public
    
    // MARK: -CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func collectionViewContentSize() -> CGSize {
        return CGSize(width: 50, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! KWDropdownBaseCollectionViewCell
        cell.update(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.datasource[indexPath.row]
        self.clickClosure(item, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        didNeedHighlightItemClosure(indexPath)
    }
}
