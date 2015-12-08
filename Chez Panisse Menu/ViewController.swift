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
    let url = NSURL(string: "http://www.chezpanisse.com/menus/cafe-menu/")!
    let fontName = "Baskerville"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: fontName, size: 25)
        titleLabel.textColor = UIColor(red: 0.2392, green: 0.2157, blue: 0.2471, alpha: 1.0)
        dateLabel.font = UIFont(name: fontName, size: 20)
        dateLabel.textColor = UIColor(red: 0.6078, green: 0.6196, blue: 0.5843, alpha: 1.0)

        self.view.backgroundColor = UIColor(red: 0.851, green: 0.8314, blue: 0.8039, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(red: 0.851, green: 0.8314, blue: 0.8039, alpha: 1.0)
        self.tableView.backgroundView?.backgroundColor = UIColor(red: 0.851, green: 0.8314, blue: 0.8039, alpha: 1.0)
        
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
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

