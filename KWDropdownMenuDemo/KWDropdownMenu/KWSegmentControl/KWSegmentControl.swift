//
//  KWSegmentControl.swift
//  KWDropdownMenuDemo
//
//  Created by wangk on 2017/4/18.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class KWSegmentButton: UIButton {
    var bottomLineView:UIView?
    convenience init() {
        self.init(frame:CGRectZero)
        
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = kDropdownMenuDefaultLayerBorderSelectedColor
        self.addSubview(bottomLineView!)
        
        weak var ws = self
        bottomLineView?.snp_makeConstraints { (make) in
            make.left.equalTo(ws!.snp_left)
            make.right.equalTo(ws!.snp_right)
            make.bottom.equalTo(ws!.snp_bottom)
            make.height.equalTo(0.5)
        }
    }
}

class KWSegmentControl: UIView {
    
    var buttons = [KWSegmentButton]()
    var selectBlock:(index:Int)->Void = {_ in}
    
    convenience init(titles:[String],
                     selectedIndex:Int = 0) {
        self.init(frame:CGRectZero)
        
        let buttonWidth = UIScreen.mainScreen().bounds.width/CGFloat(titles.count)
        for index in (0...titles.count - 1) {
            let title = titles[index]
            let button = KWSegmentButton()
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(kDropdownMenuDefaultLayerTitleColor, forState: .Normal)
            button.setTitleColor(kDropdownMenuDefaultLayerTitleSelectedColor, forState: .Selected)
            button.tag = index
            button.addTarget(self, action: #selector(KWSegmentControl.didClick(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(button)
            buttons.append(button)
            button.selected = (index == selectedIndex)
            button.bottomLineView?.hidden = (index != selectedIndex)
            
            weak var ws = self
            // 离左边的距离
            let leftSpace = CGFloat(index) * buttonWidth
            button.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(ws!.snp_left).offset(leftSpace)
                make.width.equalTo(buttonWidth)
                make.top.equalTo(ws!.snp_top)
                make.bottom.equalTo(ws!.snp_bottom)
            })
        }
    }
    
    func didClick(button:KWSegmentButton) {
        let tag = button.tag
        for tmp in buttons {
            let isCurrent = (tag == tmp.tag)
            tmp.selected = isCurrent
            tmp.bottomLineView?.hidden = !isCurrent
            selectBlock(index: tag)
        }
    }
}
