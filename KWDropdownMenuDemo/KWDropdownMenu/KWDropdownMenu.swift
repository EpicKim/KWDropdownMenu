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
            if subview.isKindOfClass(KWDropdownCollectionView.self) ||
                subview.tag == kDropdownBackgroundviewTag {
                return true
            }
        }
        return false
    }
}

extension UIViewController {
    
    func setupDropdownMenu(datasource:[KWDropdownBaseItem],
                           collectionViewClass:AnyClass,
                           designedHeight:CGFloat = kDropdownMenuDefaultItemHeight,
                           clickBlock:(index:Int)->Void) {
        
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
                ws!.didNeedShowContentView(datasource,
                                           collectionViewClass: collectionViewClass,
                                           designedHeight:designedHeight,
                                           clickBlock: clickBlock)
            }
            else {
                ws!.hideDropdownMenu()
            }
        }
    }
    
    // MARK: -Private
    func didNeedShowContentView(datasource:[KWDropdownBaseItem],
                                collectionViewClass:AnyClass,
                                designedHeight:CGFloat = kDropdownMenuDefaultItemHeight,
                                clickBlock:(index:Int)->Void) {
        if self.view.hasShowDropdownMenu() {
            return
        }
        weak var ws = self
        // ********设置选项卡***********
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let dataCount = datasource.count
        // 每行显示数
        var displayNumberPerLine = dataCount
        // 超出最大显示数
        if dataCount > kDropdownMenuMaxItemsOneLine {
            displayNumberPerLine = kDropdownMenuMaxItemsOneLine
        }
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
        cView.clickClosure = {(item, indexPath)->Void in
            for baseItem in datasource {
                baseItem.selected = false
            }
            item.selected = !item.selected
            ws!.hideDropdownMenu()
            let titleView = self.navigationItem.titleView as! KWDropdownTapView
            titleView.update(item.title)
            clickBlock(index: indexPath.row)
        }
        self.view.addSubview(cView)
        
        let remainder = dataCount % kDropdownMenuMaxItemsOneLine
        var rowCount = (dataCount - remainder)/kDropdownMenuMaxItemsOneLine
        if remainder > 0 {
            rowCount = rowCount + 1
        }
        let verticalWhiteSpace = CGFloat(rowCount - 1)*kDropdownMenuDefaultItemVerticalSpace
        let height = CGFloat(rowCount) * designedHeight + 2*kDropdwonMenuCollectionViewTopBottomInset + verticalWhiteSpace
        
        cView.snp_makeConstraints { (make) in
            make.left.equalTo(ws!.view.snp_left)
            make.right.equalTo(ws!.view.snp_right)
            make.top.equalTo(ws!.view.snp_top).offset(0)
            make.height.equalTo(height)
        }
        
        // ********设置透明背景图***********
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0.3
        backgroundView.tag = kDropdownBackgroundviewTag
        self.view.addSubview(backgroundView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideDropdownMenu))
        backgroundView.addGestureRecognizer(tap)
        
        backgroundView.snp_makeConstraints { (make) in
            make.left.equalTo(ws!.view.snp_left)
            make.right.equalTo(ws!.view.snp_right)
            make.top.equalTo(cView.snp_bottom)
            make.bottom.equalTo(ws!.view.snp_bottom)
        }
    }
    
    func hideDropdownMenu() {
        (self.navigationItem.titleView as? KWDropdownTapView)?.reset()
        for subview in self.view.subviews {
            if subview.isKindOfClass(KWDropdownCollectionView.self) ||
                subview.tag == kDropdownBackgroundviewTag {
                subview.removeFromSuperview()
            }
        }
    }
}
