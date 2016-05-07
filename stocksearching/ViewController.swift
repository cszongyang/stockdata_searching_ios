//
//  ViewController.swift
//  stock
//
//  Created by zongyang li on 4/23/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//
import Alamofire
import Alamofire_Synchronous
import SwiftyJSON
import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var ActionIndicator: UIActivityIndicatorView!
    
    @IBAction func getQuotePressed(sender: UIButton) {
        
        if searchText.text == "" {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please input a symbol"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detail = storyboard.instantiateViewControllerWithIdentifier("DetailController") as! DetailController
            
            detail.flag = true
            detail.symbol = self.symbol
            
            //    DataStorage.flag = true
            DataStorage.symbol = self.symbol
            DataStorage.stockDetailData = []
            DataStorage.newsArray = []
            
            //   self.navigationController!.pushViewController(detail, animated: true)
            
            let navController = UINavigationController(rootViewController: detail) // Creating a navigation controller with VC1 at the root of the navigation stack.
            
            self.presentViewController(navController, animated: true, completion: nil)
            
        }
        
    }
    var symbol:String = ""
    var timer = NSTimer()
    var flag:Bool = false;
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    private var symbolList: [String] = []
    
    var resultList: [NSDictionary] = []
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchDetail(sender: UIButton) {
        
    }
    
    @IBAction func refresh(sender: UIButton) {
        reloadFavoriteList(timer)
    }
    
    var autoCompleteViewController: AutoCompleteViewController!
    
    
    let countriesList = countries
    var isFirstLoad: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        
        
      //  sleep(4)
        
       // self.ActionIndicator.stopAnimating()
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        do{
            let request = NSFetchRequest(entityName:"StockInfo")
            var res: [NSManagedObject]? = try context.executeFetchRequest(request)  as? [NSManagedObject]
            
            if res!.count > 0 {
                for items in res!{
                    for item in items.valueForKey("symbol")! as! NSArray {
                        //get favorite symbols from core data
                        symbolList.append(item as! String)
                    }
                }
            }
            
            DataStorage.favoriteSymbols = symbolList
            
            
        }catch{
            print("fetch context error")
        }
        print("hehehsdflkjlfjsl")
        
        
    }
    
    
    
    func reloadFavoriteList(timer:NSTimer) {
        
        //var symbolList:[String] = self.symbolList
        
        self.ActionIndicator.startAnimating()

        
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
                            DataStorage.existInfavorite = true
                        }
                        symbolList.append(item as! String)
                    }
                }
            }
            DataStorage.favoriteSymbols = symbolList
            self.symbolList = symbolList
            
            
        }catch{
            print("fetch context error")
        }
        
        
        
        
        //issue http request for every symbol that exsits in Core data
        resultList = []
        var dict: Dictionary<String, NSDictionary>? = [:]
        
        for item in symbolList {
            let url = URLFactory.searchStockDetail(item);
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data, response, error in
                
                do{
                    let detailDictionary : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    //self.resultList.append(detailDictionary)
                    //res.append(detailDictionary)
                    
                    if dict![item] == nil {
                        dict![item] = detailDictionary
                        self.resultList = []
                    }
                    
                    if dict?.count == symbolList.count {
                        for symb in symbolList{
                            self.resultList.append(dict![symb]!)
                        }
                        dispatch_async(dispatch_get_main_queue(),{
                            self.ActionIndicator.stopAnimating()
                            self.tableView.reloadData()
                        })
                    }
                    
                }catch{
                    print("error serializing JSON: \(error)")
                }
                
            }
            task.resume()
        }
    }
    

    @IBAction func refreshSwitchChange(sender: UISwitch) {
        if sender.on {
            print("switch on")
            //var argument:String = "symbolList"
            timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("reloadFavoriteList:"), userInfo:nil, repeats:true)
        }else{
            print("switch off")
            timer.invalidate()
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let detail:DetailController = segue.destinationViewController as! DetailController
      //  detail.flag = true
        detail.symbol = self.symbol
        


        
        
        DataStorage.symbol = self.symbol
        DataStorage.stockDetailData = []
        DataStorage.newsArray = []
        
    }
    
    override func viewWillAppear(animated: Bool) {
       // super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
        reloadFavoriteList(timer)
    }
    
//    
//    let detailKeys: [String] = ["Name", "Symbol","Last Price","Change (Change Percent)","Date and Time","Market Cap","Volume","Change YTD (Change Percent YTD)","High Price","Low Price","Opening Price"]
//    
//    
    //favorite list table view  functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! favoriteListCell
        cell.symbol?.text = self.resultList[indexPath.row]["Symbol"] as? String
        cell.lastprice?.text = self.resultList[indexPath.row]["Last Price"] as? String
        
        cell.name?.text = self.resultList[indexPath.row]["Name"] as? String
        cell.marketgap?.text = self.resultList[indexPath.row]["Market Cap"] as? String
        let change: String = (self.resultList[indexPath.row]["Change (Change Percent)"] as? String)!
        
        if change[change.startIndex.advancedBy(0)] == "-" {
            cell.change?.backgroundColor = UIColor.redColor()
            cell.change?.text = change[change.startIndex.advancedBy(1)...change.startIndex.advancedBy(change.characters.count-1)]
        }
        else {
            cell.change?.backgroundColor = UIColor.redColor()
            cell.change?.text = change[change.startIndex.advancedBy(1)...change.startIndex.advancedBy(change.characters.count-1)]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultList.count
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        //let cell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! favoriteListCell
//    }
//    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        var delete = UITableViewRowAction(style: .Normal, title: "Delete"){
//            (action:UITableViewRowAction!,indexPath:NSIndexPath!) -> void in
//            let text = DataStorage.favoriteSymbols[indexPath.row]
//            
//        }
        if editingStyle == .Delete {
            self.resultList.removeAtIndex(indexPath.row)
            
            
            print(DataStorage.favoriteSymbols[indexPath.row])
            
            
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            do{
                let request = NSFetchRequest(entityName:"StockInfo")
                var res: [NSManagedObject]? = try context.executeFetchRequest(request)  as? [NSManagedObject]
                
                
                if res!.count > 0 {

                    let stock = res![0] as! NSManagedObject
                    context.deleteObject(stock)
                }
         
                symbolList = symbolList.filter{$0 != DataStorage.favoriteSymbols[indexPath.row]}
              
                DataStorage.favoriteSymbols = self.symbolList
                print("DataStorage.favoriteSymbols:")
                print(DataStorage.favoriteSymbols)
                
//                dispatch_async(dispatch_get_main_queue(),{
//
//                    self.tableView.reloadData()
//                })
                
            }catch{
                print("fetch context error")
            }
            
            var StockInfo = NSEntityDescription.insertNewObjectForEntityForName("StockInfo",inManagedObjectContext: context) as NSManagedObject
            
            StockInfo.setValue(symbolList, forKey: "symbol")
            
            do {
                try context.save()
                
            } catch {
                print("Unresolved error")
                abort()
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    
     //   let detail:DetailController = DetailController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = storyboard.instantiateViewControllerWithIdentifier("DetailController") as! DetailController
        
        detail.flag = true
        detail.symbol = symbolList[indexPath.row]
        
        
    //    DataStorage.flag = true
        DataStorage.symbol = symbolList[indexPath.row]
        DataStorage.stockDetailData = []
        DataStorage.newsArray = []
        
     //   self.navigationController!.pushViewController(detail, animated: true)
        
        let navController = UINavigationController(rootViewController: detail) // Creating a navigation controller with VC1 at the root of the navigation stack.

        
        self.presentViewController(navController, animated: true, completion: nil)
        

    }
}




func getClassName(obj : AnyObject) -> String
{
    let objectClass : AnyClass! = object_getClass(obj)
    let className = objectClass.description()
    
    return className
}




//autocomplete part

extension ViewController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.searchText
    }
    func autoCompleteThreshold(textField: UITextField) -> Int {
        return 1
    }
    
    func autoCompleteItemsForSearchTerm(symbol: String) -> [AutocompletableOption] {
//        let filteredCountries = self.countriesList.filter { (country) -> Bool in
//            return country.lowercaseString.containsString(term.lowercaseString)
//        }
//        print(filteredCountries)

        var results: [AutocompletableOption] = []
        
        var jsons: NSArray = []
        
        let url = URLFactory.companyLookup(symbol);
        
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        
        let response = Alamofire.request(.GET, "http://localhost/stock_search/stockProcess.php", parameters: ["symbol": searchText.text!]).responseJSON()
        if let json = response.result.value {
          
            for i in 0 ..< json.count  {
                var item: String = ""
                item += String(json[i]["Symbol"]!!) + "-"
                item += String(json[i]["Name"]!!) + "-"
                item += String(json[i]["Exchange"]!!)
                results.append(AutocompleteCellData(text: item,image: UIImage(named: ""),symbolValue:String(json[i]["Symbol"]!!)))
            }
        }
        
        return results
    }
    
    func autoCompleteHeight() -> CGFloat {
        return CGRectGetHeight(self.view.frame) / 3.0
    }
    
    
    func didSelectItem(item: AutocompletableOption) {
        self.searchText.text = item.text
        self.symbol = item.symbolValue
        
    }
}
