//
//  DetailController.swift
//  stock
//
//  Created by zongyang li on 4/23/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class DetailController: UIViewController, UITableViewDataSource, FBSDKLoginButtonDelegate,FBSDKSharingDelegate {
    
    @IBOutlet weak var fbBtn: FBSDKLoginButton?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currentBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addToFavorite: UIButton!
    
   
 
    @IBAction func addFavorite(sender: UIButton) {
        
        
        
        var symbolList: [String] = []
        var flag: Int = 0;
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        do{
            let request = NSFetchRequest(entityName:"StockInfo")
            var res: [NSManagedObject]? = try context.executeFetchRequest(request)  as? [NSManagedObject]
       
            
            if res!.count > 0 {
                for items in res!{
                    for item in items.valueForKey("symbol")! as! NSArray {
                        if item as! String == DataStorage.symbol {
                            flag++
                        }
                        symbolList.append(item as! String)
                    }
                }
                let stock = res![0] as! NSManagedObject
                context.deleteObject(stock)
            }
            print("flag:")
            print(flag)
            // the symbol already exsits in core data so it should be deleted
            if flag != 0 {
                symbolList = symbolList.filter{$0 != DataStorage.symbol}
                addToFavorite.setImage(UIImage(named: "star.png"), forState: UIControlState.Normal)
            }
            else{// current symbol does not exist in core data so it should be added
                symbolList.append(DataStorage.symbol)
                addToFavorite.setImage(UIImage(named: "star_filled.png"), forState: UIControlState.Normal)
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                DataStorage.favoriteSymbols = symbolList
                print("DataStorage.favoriteSymbols:")
                print(DataStorage.favoriteSymbols)
                self.tableView.reloadData()
            })
            
        }catch{
            print("fetch context error")
        }
        
        var StockInfo = NSEntityDescription.insertNewObjectForEntityForName("StockInfo",inManagedObjectContext: context) as NSManagedObject
        
        StockInfo.setValue(symbolList, forKey: "symbol")

        do {
            try context.save()
          //  print(StockInfo)
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var stockImage: UIImageView!

    
    var symbol:String = ""
    var keys:[(String,String)] = []
    var flag:Bool = false;
    
    @IBAction func fbBtnPressed(sender: AnyObject) {

        var name: String = ""
        var sym: String = ""
        var lastprice: String = ""
        
        for item in DataStorage.stockDetailData {
            if item.0 == "Last Price" {
                lastprice = item.1
            }
            else if item.0 == "Symbol" {
                sym = item.1
            }
            else if item.0 == "Name" {
                name = item.1
            }
        }
        ///http://finance.yahoo.com/q?s=goog
        
        let content = FBSDKShareLinkContent()
        content.contentTitle = "Current Stock Price of " + name + " is " + lastprice
        content.contentDescription = "Stock Information of " + name
        content.imageURL = NSURL(string: "http://chart.finance.yahoo.com/t?s=" + DataStorage.symbol + "&lang=en-US&width=200&height=200")!
        content.contentURL = NSURL(string: "http://finance.yahoo.com/q?s=" + DataStorage.symbol)
        
        
        let shareButton = FBSDKShareButton()
        shareButton.hidden = true
       // shareButton.center = CGPoint(x: view.center.x, y: 2000)
    
        shareButton.shareContent = content
        //view.addSubview(shareButton)
        
       
        shareButton.sendActionsForControlEvents(.TouchUpInside)
    }
    
    
    
    
    func btnPostMsg(sender: UIButton) {
        
        if FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions") {
            
            FBSDKGraphRequest.init(graphPath: "me/feed", parameters: ["message" : "Posted with FBSDK Graph API."], HTTPMethod: "POST").startWithCompletionHandler({ (connection, result, error) -> Void in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    self.alertShow("Message")
                }
            })
        } else {
            print("require publish_actions permissions")
        }
    }
    
    
    
    func alertShow(typeStr: String) {
        let alertController = UIAlertController(title: "", message: typeStr+" Posted!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    //////////
    
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        let alertController = UIAlertController(title: "Posted Successfully!", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        let alertController = UIAlertController(title: "Not Posted!", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        let alertController = UIAlertController(title: "Post Failed!", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    /////////////
    
    
    
    func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let _view = storyboard.instantiateViewControllerWithIdentifier("viewController") as! ViewController
        let navController = UINavigationController(rootViewController: _view)
        self.presentViewController(navController, animated: true, completion: nil)
        //self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
//    func load_image(urlString:String)
//    {
//        
//        var imgURL: NSURL = NSURL(string: urlString)!
//        let request: NSURLRequest = NSURLRequest(URL: imgURL)
//        NSURLConnection.sendAsynchronousRequest(
//            request, queue: NSOperationQueue.mainQueue(),
//            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
//                if error == nil {
//                    self.stockImage.image = UIImage(data: data!)
//                }
//        })
//        
//    }
//    
    func checkInFavorites(sym:String) -> Bool {
        var flag: Bool = false;
        
        for item in DataStorage.favoriteSymbols {
            if item as! String == sym {
                flag = true
            }
            
        }
        return flag
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
      
        currentBtn.selected = true
//        currentBtn.backgroundColor = UIColor(red: 41, green: 135, blue: 255, alpha: 0.5)
//        currentBtn.titleLabel?.textColor = UIColor.whiteColor()
////
        
        // the symbol already exsits in core data so it should be deleted
        if checkInFavorites(DataStorage.symbol) {
        
            addToFavorite.setImage(UIImage(named: "star_filled.png"), forState: UIControlState.Normal)
        }
        else{// current symbol does not exist in core data so it should be added
            addToFavorite.setImage(UIImage(named: "star.png"), forState: UIControlState.Normal)
        }
        
        

        
        //load the viewTable from localStorage
        if DataStorage.stockDetailData.count != 0 {
            self.keys = DataStorage.stockDetailData
            self.tableView.reloadData()
        }else{
            
            let detailKeys: [String] = ["Name", "Symbol","Last Price","Change (Change Percent)","Date and Time","Market Cap","Volume","Change YTD (Change Percent YTD)","High Price","Low Price","Opening Price"]
            
            
            let url = URLFactory.searchStockDetail(DataStorage.symbol);
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                
                do{
                    let detailDictionary : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    for i in 0 ..< detailKeys.count  {
                        let pair = (detailKeys[i], String(detailDictionary[detailKeys[i]]!))
                        self.keys.append(pair)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        
                        DataStorage.stockDetailData = self.keys
                        
                        self.tableView.reloadData()
                    })
            
                    
                }catch{
                    //print(self.keys.count)
                                          let alert = UIAlertView()
                        alert.title = "Alert"
                        alert.message = "invalid symbol"
                        alert.addButtonWithTitle("OK")
                        alert.show()
                        return
                   
                    print("error serializing JSON: \(error)")
                }
            }
            task.resume()
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.keys.count {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("webViewCell", forIndexPath: indexPath) as! webViewCell
    
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
    
                ///   http://chart.finance.yahoo.com/t?s="+symbol+"&lang=en-US&width="+imageWidth+"&height="+imageHeight+"'
                ///   http://chart.finance.yahoo.com/t?s=GOOG&lang=en-US&width=320&height=320
                let url = NSURL(string: "http://chart.finance.yahoo.com/t?s=" + DataStorage.symbol + "&lang=en-US&width=320&height=280")!
    
                let request = NSURLRequest(URL: url)
                cell.webView.loadRequest(request)
            })
            
            return cell
            
        }
        else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! symbolDetailCell
            if self.keys[indexPath.row].0 == "Change (Change Percent)" {
                cell.key?.text = "Change"
            }
            else if self.keys[indexPath.row].0 == "Change YTD (Change Percent YTD)" {
                cell.key?.text = "Change YTD"
            }
            else if self.keys[indexPath.row].0 == "Date and Time"{
                cell.key?.text = "Time and Date"
            }
                
            else{
                cell.key?.text = self.keys[indexPath.row].0
            }
            
            let change: String = (self.keys[indexPath.row].1 as? String)!
            
            if change[change.startIndex.advancedBy(0)] == "+" && (self.keys[indexPath.row].0 == "Change (Change Percent)" || self.keys[indexPath.row].0 == "Change YTD (Change Percent YTD)"){
                cell.cellImage.image = UIImage(named:"up.png")
            }
            else if change[change.startIndex.advancedBy(0)] == "-" && (self.keys[indexPath.row].0 == "Change (Change Percent)" || self.keys[indexPath.row].0 == "Change YTD (Change Percent YTD)"){
                print(self.keys[indexPath.row].0)
                cell.cellImage.image = UIImage(named:"down.png")
            }
            
            print(change)
            
            if self.keys[indexPath.row].0 == "Change (Change Percent)" {
                print(change[change.startIndex.advancedBy(1)...change.startIndex.advancedBy(change.characters.count-1)])
                cell.value?.text = change[change.startIndex.advancedBy(1)...change.startIndex.advancedBy(change.characters.count-1)]
            }
            else{
                cell.value?.text = self.keys[indexPath.row].1
            }
            cell.key?.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
            
            return cell
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keys.count + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == self.keys.count {
         
            let high: CGFloat = 340.0
            return high
        }
        else{
            
            let low: CGFloat = 40.0
            return low
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        //super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("login")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
//    func logUserdata(){
//        let gra = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        gra.startWithCompletionHandler{
//            
//        }
//    }

}
