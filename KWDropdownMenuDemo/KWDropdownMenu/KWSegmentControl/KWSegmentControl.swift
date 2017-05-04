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
        self.init(frame:CGRect.zero)
        
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = kDropdownMenuDefaultLayerBorderSelectedColor
        self.addSubview(bottomLineView!)
        
        weak var ws = self
        bottomLineView?.snp.makeConstraints { (make) in
            make.left.equalTo(ws!.snp.left)
            make.right.equalTo(ws!.snp.right)
            make.bottom.equalTo(ws!.snp.bottom)
            make.height.equalTo(0.5)
        }
    }
}

class KWSegmentControl: UIView {
    
    var buttons = [KWSegmentButton]()
    var selectBlock:(_ index:Int)->Void = {_ in}
    
    convenience init(titles:[String],
                     selectedIndex:Int = 0) {
        self.init(frame:CGRect.zero)
        
        let buttonWidth = UIScreen.main.bounds.width/CGFloat(titles.count)
        for index in (0...titles.count - 1) {
            let title = titles[index]
            let button = KWSegmentButton()
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(kDropdownMenuDefaultLayerTitleColor,
                                 for: UIControlState())
            button.setTitleColor(kDropdownMenuDefaultLayerTitleSelectedColor,
                                 for: .selected)
            button.tag = index
            button.addTarget(self,
                             action: #selector(KWSegmentControl.didClick(_:)),
                             for: .touchUpInside)
            self.addSubview(button)
            buttons.append(button)
            button.isSelected = (index == selectedIndex)
            button.bottomLineView?.isHidden = (index != selectedIndex)
            
            weak var ws = self
            // 离左边的距离
            let leftSpace = CGFloat(index) * buttonWidth
            button.snp.makeConstraints({ (make) in
                make.left.equalTo(ws!.snp.left).offset(leftSpace)
                make.width.equalTo(buttonWidth)
                make.top.equalTo(ws!.snp.top)
                make.bottom.equalTo(ws!.snp.bottom)
            })
        }
    }
    
    func didClick(_ button:KWSegmentButton) {
        let tag = button.tag
        for tmp in buttons {
            let isCurrent = (tag == tmp.tag)
            tmp.isSelected = isCurrent
            tmp.bottomLineView?.isHidden = !isCurrent
            selectBlock(tag)
        }
    }
}
