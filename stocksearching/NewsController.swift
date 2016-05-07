//
//  NewsController.swift
//  stock
//
//  Created by zongyang li on 4/23/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import UIKit

class NewsController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var newsBtn: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    let data:[String] = ["sdfsd","kljdfdf"]
    
    var newsList: [(String,String,String,String,String)] = []
    
    func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
        //self.navigationController?.popToRootViewControllerAnimated(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let _view = storyboard.instantiateViewControllerWithIdentifier("viewController") as! ViewController
        let navController = UINavigationController(rootViewController: _view)
        self.presentViewController(navController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsBtn.selected = true
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        // Do any additional setup after loading the view.
        
        //load the viewTable from localStorage
        if DataStorage.newsArray.count != 0 {
            self.newsList = DataStorage.newsArray
            self.tableView.reloadData()
        }else{
            
            let url = URLFactory.getNews(DataStorage.symbol);
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                
                do{
                    let newsArray : [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
                  
                    
                    for i in 0 ..< newsArray.count  {
                        let tuple = (String(newsArray[i]["title"]!), String(newsArray[i]["content"]!),String(newsArray[i]["publisher"]!), String(newsArray[i]["publishedDate"]!), String(newsArray[i]["url"]!))
                        self.newsList.append(tuple)
                    }
                    DataStorage.newsArray = self.newsList
                    
                    print(newsArray)
                    
                    dispatch_async(dispatch_get_main_queue(),{
                     //   DataStorage.stockDetailData = self.keys
                        self.tableView.reloadData()
                    })
                   
                    
                }catch{
                    print("error serializing JSON: \(error)")
                }
                
            }
            task.resume()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = self.newsList[indexPath.row].0
//        print(self.newsList[indexPath.row])
//        print("hadfhsldjflks")
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.newsList.count
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! newsCell
        
        cell.title?.text = self.newsList[indexPath.row].0
        cell.content?.text = self.newsList[indexPath.row].1
        cell.publisher?.text = self.newsList[indexPath.row].2
        cell.date?.text = self.newsList[indexPath.row].3
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("here")
        print(self.newsList[indexPath.row].4)
        let url =  NSURL(string: self.newsList[indexPath.row].4)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    override func viewWillAppear(animated: Bool) {
        //super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    
}
