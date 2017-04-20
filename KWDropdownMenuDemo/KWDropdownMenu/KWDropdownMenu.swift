//
//  KWDropdownMenu.swift
//  KWDropdownMenu
//
//  Created by wangk on 17/1/10.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit
import SnapKit

let kDropdownBackgroundviewTag = 1

extension UIView {
    func hasShowDropdownMenu() -> Bool {
        for subview in self.subviews {
            if subview.isKind(of: KWDropdownCollectionView.self) ||
                subview.tag == kDropdownBackgroundviewTag {
                return true
            }
        }
        return false
    }
}
private var key: Void?
private var multiDatasourceKey: Void?
private var selectedItemKey: Void?
private var currentDropdownSectionKey: Void?

// MARK: -Runtime添加属性
extension UIViewController {
    @IBInspectable var currentDropdownSection: Int? {
        get {
            return objc_getAssociatedObject(self, &currentDropdownSectionKey) as? Int
        }
        set(newValue) {
            objc_setAssociatedObject(self, &currentDropdownSectionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var dropDownDatasource: [KWDropdownBaseItem]? {
        get {
            return objc_getAssociatedObject(self, &key) as? [KWDropdownBaseItem]
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var multiDropDownDatasource: [[KWDropdownBaseItem]]? {
        get {
            return objc_getAssociatedObject(self, &multiDatasourceKey) as? [[KWDropdownBaseItem]]
        }
        set(newValue) {
            objc_setAssociatedObject(self, &multiDatasourceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var selectedItem: KWDropdownBaseItem? {
        get {
            return objc_getAssociatedObject(self, &selectedItemKey) as? KWDropdownBaseItem
        }
        set(newValue) {
            objc_setAssociatedObject(self, &selectedItemKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // MARK: -更新
    func updateDropdownMenuSelectedIndex(_ index:Int) {
        if self.dropDownDatasource == nil {
            return
        }
        for item in self.dropDownDatasource! {
            item.selected = false
        }
        let tmpItem = self.dropDownDatasource![index]
        tmpItem.selected = true
        (self.navigationItem.titleView as? KWDropdownTapView)?.update(tmpItem.title)
    }
    // MARK: -初始化多个section的下拉列表
    func setupMultiDropdownMenu(_ datasource:[[KWDropdownBaseItem]],
                                segmentTitles:[String],
                                collectionViewClass:AnyClass,
                                designedHeight:CGFloat = kDropdownMenuDefaultItemHeight,
                                backgroundColor:UIColor = UIColor.white,
                                clickBlock:@escaping (_ section:Int,_ index:Int)->Void,
                                didNeedHighLightBlock:(_ cell:UICollectionViewCell)->Void = {_ in}) {
        if datasource.count == 0 {
            return
        }
        self.selectedItem = datasource.first?.first
        self.multiDropDownDatasource = datasource
        weak var ws = self
        
        var tmpTitle = self.title
        if tmpTitle == nil {
            for array in datasource {
                for item in array {
                    if item.selected == true {
                        tmpTitle = item.title
                        break
                    }
                }
            }
        }
        // ********设置标题***********
        self.title = ""
        let tapView = KWDropdownTapView(title: tmpTitle!)
        self.navigationItem.titleView = tapView
        
        // ********事件***********
        tapView.clickBlock = {(expanded)->Void in
            if expanded {
                var customViews = [UIView]()
                var heights = [CGFloat]()
                for i in 0...(datasource.count - 1) {
                    let array = datasource[i]
                    let height = UIViewController.getDropdownCollectionViewHeight(array.count, designedHeight: designedHeight)
                    let cview = self.getCollectionView(array, collectionViewClass: collectionViewClass,
                                                       backgroundColor:backgroundColor,
                                                       clickBlock: { (index) in
                        for tmp in datasource {
                            for item in tmp {
                                item.selected = false
                            }
                        }
                        datasource[i][index].selected = true
                        ws?.currentDropdownSection = i
                        clickBlock(i, index)
                    })
                    customViews.append(cview)
                    heights.append(height)
                }
                
                let selectedIndex = self.currentDropdownSection == nil ? 0:self.currentDropdownSection!
                let seg = KWSegmentControlView(titles: segmentTitles,
                                               views: customViews,
                                               heights: heights,
                                               selectedIndex: selectedIndex)
                seg.show(self.view)
                
                self.addShadowView(seg.snp.bottom)
            }
            else {
                ws!.hideDropdownMenu()
            }
        }
    }
    // MARK: -初始化单个section的下拉列表
    func setupDropdownMenu(_ datasource:[KWDropdownBaseItem],
                           collectionViewClass:AnyClass,
                           designedHeight:CGFloat = kDropdownMenuDefaultItemHeight,
                           backgroundColor:UIColor = UIColor.white,
                           clickBlock:@escaping (_ index:Int)->Void,
                           didNeedHighLightBlock:@escaping (_ cell:UICollectionViewCell)->Void = {_ in}) {
        if datasource.count == 0 {
            return
        }
        self.selectedItem = datasource.first
        self.dropDownDatasource = datasource
        weak var ws = self
        
        var tmpTitle = self.title
        if tmpTitle == nil {
            for item in datasource {
                if item.selected == true {
                    tmpTitle = item.title
                    break
                }
            }
        }
        // ********设置标题***********
        self.title = ""
        let tapView = KWDropdownTapView(title: tmpTitle!)
        self.navigationItem.titleView = tapView
        
        // ********事件***********
        tapView.clickBlock = {(expanded)->Void in
            if expanded {
                ws!.didNeedShowContentView(ws!.dropDownDatasource!,
                                           collectionViewClass: collectionViewClass,
                                           designedHeight:designedHeight,
                                           backgroundColor:backgroundColor,
                                           clickBlock: clickBlock,
                                           didNeedHighLightBlock: didNeedHighLightBlock)
            }
            else {
                ws!.hideDropdownMenu()
            }
        }
    }
    
    // MARK: -Static
    static func getDropdownCollectionViewHeight(_ dataCount:Int,
                                        designedHeight:CGFloat) -> CGFloat {
        let remainder = dataCount % kDropdownMenuMaxItemsOneLine
        var rowCount = (dataCount - remainder)/kDropdownMenuMaxItemsOneLine
        if remainder > 0 {
            rowCount = rowCount + 1
        }
        let verticalWhiteSpace = CGFloat(rowCount - 1)*kDropdownMenuDefaultItemVerticalSpace
        let height = CGFloat(rowCount) * designedHeight + 2*kDropdwonMenuCollectionViewTopBottomInset + verticalWhiteSpace
        return height
    }
    
    // MARK: -Private
    // 设置不透明的底图，点击隐藏展开视图
    func addShadowView(_ topConstrait:ConstraintItem) {
        // ********设置透明背景图***********
        weak var ws = self
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.3
        backgroundView.tag = kDropdownBackgroundviewTag
        self.view.addSubview(backgroundView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideDropdownMenu))
        backgroundView.addGestureRecognizer(tap)
        
        backgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(ws!.view.snp.left)
            make.right.equalTo(ws!.view.snp.right)
            make.top.equalTo(topConstrait)
            make.bottom.equalTo(ws!.view.snp.bottom)
        }
    }
    
    func getCollectionView(_ datasource:[KWDropdownBaseItem],
                           collectionViewClass:AnyClass,
                           designedHeight:CGFloat = kDropdownMenuDefaultItemHeight,
                           section:Int = 0,
                           backgroundColor:UIColor,
                           clickBlock:@escaping (_ index:Int)->Void,
                           didNeedHighLightBlock:@escaping (_ cell:UICollectionViewCell)->Void = {_ in}) -> UICollectionView {
        weak var ws = self
        let screenWidth = UIScreen.main.bounds.size.width
        let displayNumberPerLine = 3
        // 选项高度
        let itemHeight = designedHeight
        // 总空白间距
        let whiteSpace = CGFloat(displayNumberPerLine - 1) * kDropdownMenuDefaultItemHorizontalSpace + kDropdwonMenuCollectionViewLeftRightInset*2
        // 选项宽度
        let itemWidth = (screenWidth - whiteSpace)/CGFloat(displayNumberPerLine)
        
        let cView = KWDropdownCollectionView(itemWidth: itemWidth,
                                             height: itemHeight,
                                             minimumLineSpacing: kDropdownMenuDefaultItemVerticalSpace,
                                             minimumInteritemSpacing: kDropdownMenuDefaultItemHorizontalSpace,
                                             collectionViewClass: collectionViewClass,
                                             datasource: datasource)
        cView.backgroundColor = backgroundColor
        cView.clickClosure = {(item, indexPath)->Void in
            for baseItem in datasource {
                baseItem.selected = false
            }
            item.selected = !item.selected
            ws!.hideDropdownMenu()
            let titleView = ws!.navigationItem.titleView as! KWDropdownTapView
            titleView.update(item.title)
            ws!.selectedItem = datasource[indexPath.row]
            clickBlock(indexPath.row)
        }
        cView.didNeedHighlightItemClosure = {(indexPath)->Void in
            let cell = cView.cellForItem(at: indexPath as IndexPath)
            didNeedHighLightBlock(cell!)
        }
        
        return cView
    }

    func didNeedShowContentView(_ datasource:[KWDropdownBaseItem],
                                collectionViewClass:AnyClass,
                                designedHeight:CGFloat = kDropdownMenuDefaultItemHeight,
                                backgroundColor:UIColor = UIColor.white,
                                clickBlock:@escaping (_ index:Int)->Void,
                                didNeedHighLightBlock:@escaping (_ cell:UICollectionViewCell)->Void = {_ in}) {
        if self.view.hasShowDropdownMenu() {
            return
        }
        weak var ws = self
        // ********设置选项卡***********
        let cView = self.getCollectionView(datasource,
                                           collectionViewClass: collectionViewClass,
                                           designedHeight: designedHeight,
                                           backgroundColor:backgroundColor,
                                           clickBlock: clickBlock,
                                           didNeedHighLightBlock: didNeedHighLightBlock)
        self.view.addSubview(cView)
        
        let height = UIViewController.getDropdownCollectionViewHeight(datasource.count, designedHeight: designedHeight)
        
        cView.snp.makeConstraints { (make) in
            make.left.equalTo(ws!.view.snp.left)
            make.right.equalTo(ws!.view.snp.right)
            make.top.equalTo(ws!.view.snp.top).offset(0)
            make.height.equalTo(height)
        }
        
        // ********设置透明背景图***********
        self.addShadowView(cView.snp.bottom)
    }
    
    func hideDropdownMenu() {
        (self.navigationItem.titleView as? KWDropdownTapView)?.reset()
        for subview in self.view.subviews {
            if subview.isKind(of: KWDropdownCollectionView.self) ||
               subview.tag == kDropdownBackgroundviewTag ||
               subview.isKind(of: KWSegmentControlView.self) {
                subview.removeFromSuperview()
            }
        }
    }
}
