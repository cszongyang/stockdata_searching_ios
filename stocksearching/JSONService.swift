//
//  JSONService.swift
//  stockSearch
//
//  Created by zongyang li on 4/19/16.
//  Copyright © 2016 zongyang li. All rights reserved.
//

import Foundation

class JSONService{
    
    init(_ name: String, _ url: NSURL)
    {
        self.name = name
        self.url  = url
    }
    
    /** Prepares a GET request for the specified URL. */
    class func GET(url: NSURL) -> JSONService
    {
        let service = JSONService("GET", url)
        return service
    }
    

    func resultHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
        
        do{
            let detailDictionary : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            for i in 0 ..< self.detailKeys.count  {
                let pair = (self.detailKeys[i], String(detailDictionary[self.detailKeys[i]]!))
                self.keys.append(pair)
            }
            
            //  completionHandler("hehe")
            
        }catch{
            print("error serializing JSON: \(error)")
        }
        
    }

    
    func execute()
    {
        //var keys:[(String,String)] = []
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = name
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler: resultHandler)
//        {
//            data, response, error in
//            
////            if let data = data,
////                jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
////                where error == nil {
////                var boardsDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: error) as Array<NSDictionary>
////
////                print(boardsDictionary)
////            } else {
////                print("error=\(error!.localizedDescription)")
////            }
//            
//            do{
//                let detailDictionary : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//                
//                for i in 0 ..< self.detailKeys.count  {
//                    let pair = (self.detailKeys[i], String(detailDictionary[self.detailKeys[i]]!))
//                    self.keys.append(pair)
//                }
//                
//                //print(self.keys)
//              //  completionHandler("hehe")
//                
//            }catch{
//                print("error serializing JSON: \(error)")
//            }
           
//        }
        task.resume()
        
    }
    
    func getKeyValuepairs() -> [(String,String)] {
        return keys
    }
    

    
    private let
    name: String,
    url:  NSURL
    let detailKeys: [String] = ["Name", "Symbol","Last Price","Change (Change Percent)","Date and Time","Market Cap","Volume","Change YTD (Change Percent YTD)","High Price","Low Price","Opening Price"]
    var keys:[(String,String)] = []
}
