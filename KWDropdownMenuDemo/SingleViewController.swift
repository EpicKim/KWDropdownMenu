//
//  ViewController.swift
//  KWDropdownMenu
//
//  Created by wangk on 17/1/10.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge()
        self.title = "一个试的哥哥"
        let datasource = [KWDropdownBaseItem(title:"1", selected: true),
                          KWDropdownBaseItem(title:"2"),
                          KWDropdownBaseItem(title:"3"),
                          KWDropdownBaseItem(title:"4"),
                          KWDropdownBaseItem(title:"5"),
                          KWDropdownBaseItem(title:"6"),
                          KWDropdownBaseItem(title:"7"),
                          KWDropdownBaseItem(title:"8"),
                          KWDropdownBaseItem(title:"8"),
                          KWDropdownBaseItem(title:"8"),
                          KWDropdownBaseItem(title:"8"),
                          KWDropdownBaseItem(title:"随意试试")]
                self.setupDropdownMenu(datasource,
                                       collectionViewClass: KWDropdownBaseCollectionViewCell.self,
                                       clickBlock: {(index)->Void in
                    
                })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

