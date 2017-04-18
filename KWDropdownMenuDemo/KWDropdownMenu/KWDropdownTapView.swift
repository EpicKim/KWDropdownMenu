//
//  KWDropdownTapView.swift
//  KWDropdownMenu
//  自定义titleView
//  Created by wangk on 17/1/11.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit
import SnapKit
// 标题栏点击视图
class KWDropdownTapView: UIView {
    
    var expanded = false
    
    var clickBlock:(expanded:Bool)->Void = {_ in }
    
    var titleLabel = UILabel()
    
    var titleImageView = UIImageView()
    
    convenience init(title:String) {
        // TODO: 计算label宽度
        let width = CGFloat((title as NSString).length) * 17.8
        self.init(frame: CGRectMake(0, 0, width, 40))
        // 标题
        titleLabel.textColor = kDropdownMenuTitleColor
        titleLabel.text = title
        self.addSubview(titleLabel)
        
        titleImageView.image = kDropdwonMenuTitleDownImage
        self.addSubview(titleImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(KWDropdownTapView.didClickOnTitle))
        self.addGestureRecognizer(tap)
        
        weak var ws = self
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(ws!.snp_left)
            make.centerY.equalTo(ws!.snp_centerY)
        }
        
        titleImageView.snp_makeConstraints { (make) in
            make.left.equalTo(ws!.titleLabel.snp_right).offset(2)
            make.centerY.equalTo(ws!.titleLabel.snp_centerY)
        }
    }
    // MARK: -Private
    // 点击事件
    func didClickOnTitle() {
        expanded = !expanded
        if expanded {
            titleImageView.image = kDropdwonMenuTitleUpperImage
        }
        else {
            titleImageView.image = kDropdwonMenuTitleDownImage
        }
        clickBlock(expanded: expanded)
    }
    
    // MARK: -Public
    func reset() {
        expanded = false
        titleImageView.image = kDropdwonMenuTitleDownImage
    }
    
    func update(title:String) {
        self.reset()
        let width = CGFloat((title as NSString).length) * 17.8
        self.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - width)/2, self.frame.origin.y, width, 40)
        titleLabel.text = title
    }
}
