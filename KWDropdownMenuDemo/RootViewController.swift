//
//  RootViewController.swift
//  KWDropdownMenuDemo
//
//  Created by wangk on 2017/4/18.
//  Copyright © 2017年 wangk. All rights reserved.
//

import UIKit

class RootViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource {

    var tableView:UITableView!
    var datasource = ["单个section", "多个section"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        weak var ws = self
        tableView.snp_makeConstraints { (make) in
            make.left.equalTo(ws!.view.snp_left)
            make.right.equalTo(ws!.view.snp_right)
            make.top.equalTo(ws!.view.snp_top)
            make.bottom.equalTo(ws!.view.snp_bottom)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = datasource[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(SingleViewController(), animated: true)
        }
        else if indexPath.row == 1 {
            self.navigationController?.pushViewController(MultiViewController(), animated: true)
        }
    }
}
