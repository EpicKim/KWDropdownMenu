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
    
    var clickBlock:(_ expanded:Bool)->Void = {_ in }
    
    var titleLabel = UILabel()
    
    var titleImageView = UIImageView()
    
    convenience init(title:String) {
        // TODO: 计算label宽度
        let width = CGFloat((title as NSString).length) * 17.8
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        // 标题
        titleLabel.textColor = kDropdownMenuTitleColor
        titleLabel.text = title
        self.addSubview(titleLabel)
        
        titleImageView.image = kDropdwonMenuTitleDownImage
        self.addSubview(titleImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(KWDropdownTapView.didClickOnTitle))
        self.addGestureRecognizer(tap)
        
        weak var ws = self
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ws!.snp.left)
            make.centerY.equalTo(ws!.snp.centerY)
        }
        
        titleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(ws!.titleLabel.snp.right).offset(2)
            make.centerY.equalTo(ws!.titleLabel.snp.centerY)
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
        clickBlock(expanded)
    }
    
    // MARK: -Public
    func reset() {
        expanded = false
        titleImageView.image = kDropdwonMenuTitleDownImage
    }
    
    func update(_ title:String) {
        self.reset()
        let width = CGFloat((title as NSString).length) * 17.8
        self.frame = CGRect(x: (UIScreen.main.bounds.size.width - width)/2, y: self.frame.origin.y, width: width, height: 40)
        titleLabel.text = title
    }
}
