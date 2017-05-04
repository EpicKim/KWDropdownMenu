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
    
    var titles:[String]!
    
    var segmentHeight:CGFloat! {
        get {
            return titles.count == 1 ? 0:KWSegmentControlView.headerHeight
        }
    }
    
    var selectedIndex:Int! {
        didSet(newValue) {
            for i in 0...(contentViews.count - 1) {
                let view = contentViews[i]
                view.isHidden = (newValue != i)
            }
        }
    }
    
    convenience init(titles:[String],
                     views:[UIView],
                     heights:[CGFloat],
                     selectedIndex:Int = 0) {
        self.init(frame:CGRect.zero)
        
        weak var ws = self
        
        self.heights = heights

        self.contentViews = views
        
        self.titles = titles
        
        let seg = KWSegmentControl(titles: titles,
                                   selectedIndex: selectedIndex)
        seg.selectBlock = {(index)->Void in
            // 显示制定index的view
            ws?.selectedIndex = index
            // 更新约束
            ws?.snp.updateConstraints({ (make) in
                make.left.equalTo(ws!.baseView!.snp.left)
                make.right.equalTo(ws!.baseView!.snp.right)
                make.top.equalTo(ws!.baseView!.snp.top)
                make.height.equalTo(KWSegmentControlView.headerHeight + heights[index])
            })
        }
        self.addSubview(seg)

        seg.snp.makeConstraints({ (make) in
            make.left.equalTo(ws!.snp.left)
            make.right.equalTo(ws!.snp.right)
            make.top.equalTo(ws!.snp.top)
            make.height.equalTo(ws!.segmentHeight!)
        })
        
        for index in 0...(views.count - 1) {
            let view = views[index]
            self.addSubview(view)
            
            let height = heights[index]
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(ws!.snp.left)
                make.right.equalTo(ws!.snp.right)
                make.top.equalTo(seg.snp.bottom)
                make.height.equalTo(height)
            })
        }
        
        self.selectedIndex = selectedIndex
        for i in 0...(contentViews.count - 1) {
            let view = contentViews[i]
            view.isHidden = (selectedIndex != i)
        }
    }
    
    func show(_ baseView:UIView) {
        self.baseView = baseView
        baseView.addSubview(self)
        
        weak var ws = self
        self.snp.makeConstraints({ (make) in
            make.left.equalTo(baseView.snp.left)
            make.right.equalTo(baseView.snp.right)
            make.top.equalTo(baseView.snp.top)
            make.height.equalTo(ws!.segmentHeight! + heights[selectedIndex])
        })
    }
}
