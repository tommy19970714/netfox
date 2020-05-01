//
//  LogTableViewController.swift
//  netfox_ios_demo
//
//  Created by 冨平準喜 on 2020/04/24.
//  Copyright © 2020 kasketis. All rights reserved.
//

import Foundation
import UIKit
import netfox_ios

extension NSNotification.Name {
    static let NFXDeactivateSearch = Notification.Name("NFXDeactivateSearch")
    static let NFXReloadData = Notification.Name("NFXReloadData")
    static let NFXAddedModel = Notification.Name("NFXAddedModel")
    static let NFXClearedModels = Notification.Name("NFXClearedModels")
}


class LogTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var logs = [netfox_ios.NFXHTTPModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(ListCell.self, forCellReuseIdentifier: NSStringFromClass(ListCell.self))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LogTableViewController.reloadTableViewData),
            name: NSNotification.Name.NFXReloadData,
            object: nil)
    }
    
    @objc func reloadTableViewData()
    {
//        let filterName = "IMAGE"
//        let predicate = NSPredicate(format: "shortType == '\(filterName)'")
//        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
        
        let searchString = "mpegurl"
        let predicateURL = NSPredicate(format: "requestURL contains[cd] '\(searchString)'")
        let predicateMethod = NSPredicate(format: "requestMethod contains[cd] '\(searchString)'")
        let predicateType = NSPredicate(format: "responseType contains[cd] '\(searchString)'")
        let predicates = [predicateType]
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.getModels() as NSArray).filtered(using: searchPredicate)
//        let array = NFXHTTPModelManager.sharedInstance.getModels() as NSArray
        self.logs = array as! [NFXHTTPModel]
        
        DispatchQueue.main.async { () -> Void in
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
}

extension LogTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ListCell.self), for: indexPath) as! ListCell
        
        let obj = logs[(indexPath as NSIndexPath).row]
        cell.configForObject(obj)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58
    }
}
