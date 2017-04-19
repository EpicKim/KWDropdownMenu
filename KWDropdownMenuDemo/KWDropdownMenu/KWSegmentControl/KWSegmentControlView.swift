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
    
    var contentViews:[UIView]!
    
    var baseView:UIView?
    
    var selectedIndex:Int! {
        didSet(newValue) {
            for i in 0...(contentViews.count - 1) {
                let view = contentViews[i]
                view.hidden = (newValue != i)
            }
        }
    }
    
    convenience init(titles:[String],
                     views:[UIView],
                     heights:[CGFloat],
                     selectedIndex:Int = 0) {
        self.init(frame:CGRectZero)
        
        weak var ws = self
        
        self.heights = heights

        self.contentViews = views
        
        let seg = KWSegmentControl(titles: titles,
                                   selectedIndex: selectedIndex)
        seg.selectBlock = {(index)->Void in
            // 显示制定index的view
            ws?.selectedIndex = index
            // 更新约束
            ws?.snp_updateConstraints(closure: { (make) in
                make.left.equalTo(ws!.baseView!.snp_left)
                make.right.equalTo(ws!.baseView!.snp_right)
                make.top.equalTo(ws!.baseView!.snp_top)
                make.height.equalTo(KWSegmentControlView.headerHeight + heights[index])
            })
        }
        self.addSubview(seg)
        
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
        
        self.selectedIndex = selectedIndex
        for i in 0...(contentViews.count - 1) {
            let view = contentViews[i]
            view.hidden = (selectedIndex != i)
        }
    }
    
    func show(baseView:UIView) {
        self.baseView = baseView
        baseView.addSubview(self)
        
        self.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(baseView.snp_left)
            make.right.equalTo(baseView.snp_right)
            make.top.equalTo(baseView.snp_top)
            make.height.equalTo(KWSegmentControlView.headerHeight + heights[selectedIndex])
        })
    }
}
