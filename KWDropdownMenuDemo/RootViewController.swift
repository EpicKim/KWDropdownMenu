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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        weak var ws = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(ws!.view.snp.left)
            make.right.equalTo(ws!.view.snp.right)
            make.top.equalTo(ws!.view.snp.top)
            make.bottom.equalTo(ws!.view.snp.bottom)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(SingleViewController(), animated: true)
        }
        else if indexPath.row == 1 {
            self.navigationController?.pushViewController(MultiViewController(), animated: true)
        }
    }
}
