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
    convenience init(title:String) {
        // TODO: 计算label宽度
        let width = CGFloat((title as NSString).length) * 17.8
        self.init(frame: CGRectMake(0, 0, width, 40))
        // 标题
        titleLabel.textColor = kDropdownMenuTitleColor
        titleLabel.text = title
        self.addSubview(titleLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(KWDropdownTapView.didClickOnTitle))
        self.addGestureRecognizer(tap)
        
        weak var ws = self
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(ws!.snp_left)
            make.centerY.equalTo(ws!.snp_centerY)
        }
    }
    // MARK: -Private
    // 点击事件
    func didClickOnTitle() {
        expanded = !expanded
        clickBlock(expanded: expanded)
    }
    
    // MARK: -Public
    func reset() {
        expanded = false
    }
    
    func update(title:String) {
        titleLabel.text = title
        let width = CGFloat((title as NSString).length) * 17.8
        self.frame = CGRectMake(0, 0, width, 40)
    }
}
