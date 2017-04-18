//
//  KWDropdownBasicCollectionViewCell.swift
//  KWDropdownMenu
//
//  Created by wangk on 17/1/12.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class KWDropdownBaseCollectionViewCell:UICollectionViewCell {
    var basicLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if self.didNeedLoadBasicUI() {
            self.layer.cornerRadius = kDropdownMenuDefaultCornerRadius
            self.layer.borderWidth = 0.5
            
            basicLabel.text = ""
            basicLabel.font = UIFont.systemFontOfSize(kDropdownMenuDefaultTitleSize)
            self.addSubview(basicLabel)
            
            weak var ws = self
            basicLabel.snp_makeConstraints { (make) in
                make.centerX.equalTo(ws!.snp_centerX)
                make.centerY.equalTo(ws!.snp_centerY)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: KWDropdownBaseItem) {
        basicLabel.text = item.title
        if item.selected {
            self.layer.borderColor = kDropdownMenuDefaultLayerBorderSelectedColor.CGColor
            basicLabel.textColor = kDropdownMenuDefaultLayerTitleSelectedColor
        }
        else {
            self.layer.borderColor = kDropdownMenuDefaultLayerBorderColor.CGColor
            basicLabel.textColor = kDropdownMenuDefaultLayerTitleColor
        }
    }
    
    func didNeedLoadBasicUI() -> Bool {
        return true
    }
}
