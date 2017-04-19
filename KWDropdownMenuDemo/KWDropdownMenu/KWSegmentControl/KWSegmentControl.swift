//
//  KWSegmentControl.swift
//  KWDropdownMenuDemo
//
//  Created by wangk on 2017/4/18.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class KWSegmentControl: UIView {
    
    var buttons = [UIButton]()
    var selectBlock:(index:Int)->Void = {_ in}
    
    convenience init(titles:[String],
                     selectedIndex:Int = 0) {
        self.init(frame:CGRectZero)
        
        let buttonWidth = UIScreen.mainScreen().bounds.width/CGFloat(titles.count)
        for index in (0...titles.count - 1) {
            let title = titles[index]
            let button = UIButton(type: .Custom)
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(kDropdownMenuDefaultLayerTitleColor, forState: .Normal)
            button.setTitleColor(kDropdownMenuDefaultLayerTitleSelectedColor, forState: .Selected)
            button.tag = index
            button.addTarget(self, action: #selector(KWSegmentControl.didClick(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(button)
            buttons.append(button)
            button.selected = (index == selectedIndex)
            
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
    
    func didClick(button:UIButton) {
        let tag = button.tag
        for tmp in buttons {
            let isCurrent = (tag == tmp.tag)
            tmp.selected = isCurrent
            selectBlock(index: tag)
        }
    }
}
