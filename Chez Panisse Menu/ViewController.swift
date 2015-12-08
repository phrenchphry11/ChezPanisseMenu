//
//  ViewController.swift
//  Chez Panisse Menu
//
//  Created by Holly French on 12/2/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var menuItems: [NSDictionary]?
    var dateHeader: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: "Baskerville", size: 25)
        dateLabel.font = UIFont(name: "Baskerville", size: 20)

        let url = NSURL(string: "http://www.chezpanisse.com/menus/cafe-menu/")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let htmlData = NSString(data: data, encoding: NSUTF8StringEncoding)
            let doc = TFHpple(HTMLData: data)
            var menuPriceRegex = NSRegularExpression(pattern: "\\$\\d{1,8}", options: nil, error: nil)
            
            if let elements = doc.searchWithXPathQuery("////div/p") as? [TFHppleElement] {
                self.menuItems = []
                for element in elements {
                    if let menuItem = element.firstChild.content as String! {
                        if (menuItem.lowercaseString.rangeOfString("our produce, meat, poultry, and fish comes from farms, ranches") != nil) {
                            continue
                        }
                        
                        if (menuItem.lowercaseString.rangeOfString("menu start") == nil &&
                            menuItem.lowercaseString.rangeOfString("lunch") == nil &&
                            menuItem.lowercaseString.rangeOfString("dinner") == nil) {
                                var menuItem = ""
                                for itemContent in element.children {
                                    if let itemContentToAppend = itemContent as? TFHppleElement {
                                        if let itemContentStringToAppend = itemContentToAppend.content {
                                            menuItem += itemContentToAppend.content
                                        }
                                    }
                                }
                                var range = NSMakeRange(0, count(menuItem))
                                var match = menuPriceRegex?.firstMatchInString(menuItem, options: nil, range: range)
                                var price: String?
                                var menuDict: [String: String] = [:]
                                if let priceRange = match {
                                    price = (menuItem as NSString).substringWithRange(priceRange.range)
                                    menuItem = menuPriceRegex!.stringByReplacingMatchesInString(menuItem, options: nil, range: range, withTemplate: "")
                                    menuItem = menuItem.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                                    menuItem = menuItem.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
                                }
                                menuDict["menuItem"] = menuItem
                                menuDict["price"] = price
                                self.menuItems!.append(menuDict)
                        } else if (menuItem.lowercaseString.rangeOfString("lunch") != nil ||
                            menuItem.lowercaseString.rangeOfString("dinner") != nil) {
                                self.dateHeader = menuItem
                        }
                    }
                }
            }
            self.dateHeaderLabel.text = self.dateHeader
            self.tableView.reloadData()
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateHeaderLabel: UILabel!

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let menuItems = menuItems {
            return menuItems.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as! MenuItemCell
        let menuItem = menuItems![indexPath.row]
        
        cell.menuText.text = menuItem["menuItem"] as? String
        cell.price.text = menuItem["price"] as? String
        return cell
    }
}

