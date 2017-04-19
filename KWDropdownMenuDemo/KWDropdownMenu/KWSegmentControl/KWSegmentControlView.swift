//
//  KWSegmentControlView.swift
//  KWDropdownMenuDemo
//
//  Created by wangk on 2017/4/18.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class KWSegmentControlView: UIView {
    // segmentControl高度
    static var headerHeight:CGFloat = 40
    
    var heights:[CGFloat]!
    
    var baseView:UIView?
    
    convenience init(titles:[String],
                     views:[UIView],
                     heights:[CGFloat],
                     selectedIndex:Int = 0) {
        self.init(frame:CGRectZero)
        
        weak var ws = self
        
        self.heights = heights
        
        let seg = KWSegmentControl(titles: titles,
                                   selectedIndex: selectedIndex)
        seg.selectBlock = {(index)->Void in
            for i in 0...(views.count - 1) {
                let view = views[i]
                view.hidden = (index != i)
                
                self.snp_updateConstraints(closure: { (make) in
                    make.left.equalTo(ws!.baseView!.snp_left)
                    make.right.equalTo(ws!.baseView!.snp_right)
                    make.top.equalTo(ws!.baseView!.snp_top)
                    make.height.equalTo(KWSegmentControlView.headerHeight + heights[i])
                })
            }
        }
        self.addSubview(seg)
        for i in 0...(views.count - 1) {
            let view = views[i]
            view.hidden = (selectedIndex != i)
        }
        
        seg.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(ws!.snp_left)
            make.right.equalTo(ws!.snp_right)
            make.top.equalTo(ws!.snp_top)
            make.height.equalTo(KWSegmentControlView.headerHeight)
        })
        
        for index in 0...(views.count - 1) {
            let view = views[index]
            self.addSubview(view)
            
            let height = heights[index]
            view.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(ws!.snp_left)
                make.right.equalTo(ws!.snp_right)
                make.top.equalTo(seg.snp_bottom)
                make.height.equalTo(height)
            })
        }
    }
    
    func show(baseView:UIView) {
        self.baseView = baseView
        baseView.addSubview(self)
        
        self.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(baseView.snp_left)
            make.right.equalTo(baseView.snp_right)
            make.top.equalTo(baseView.snp_top)
            make.height.equalTo(KWSegmentControlView.headerHeight + heights.first!)
        })
    }
}
