
//
//  MultiViewController.swift
//  KWDropdownMenuDemo
//
//  Created by wangk on 2017/4/18.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class MultiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.edgesForExtendedLayout = UIRectEdge()
        
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
        
        let datasource3 = [KWDropdownBaseItem(title:"ggg"),
                           KWDropdownBaseItem(title:"eee"),
                           KWDropdownBaseItem(title:"222"),
                           KWDropdownBaseItem(title:"hehwe"),
                           KWDropdownBaseItem(title:"hewhw"),
                           KWDropdownBaseItem(title:"6")]
        
        self.setupMultiDropdownMenu([datasource,datasource3],
                                     segmentTitles: ["seg1", "seg2"],
                                     collectionViewClass: KWDropdownBaseCollectionViewCell.self,
                                     backgroundColor:UIColor.white,
                                     clickBlock: { (section,index) in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
