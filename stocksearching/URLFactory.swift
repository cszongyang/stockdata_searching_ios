//
//  URLFactory.swift
//  stockSearch
//
//  Created by zongyang li on 4/19/16.
//  Copyright © 2016 zongyang li. All rights reserved.
//

import Foundation

class URLFactory{
    
    class func searchStockDetail(symbol: String) ->NSURL
    {
        ///let baseURL = "http://localhost/stock_search/stockProcess.php?symbolDetail="
        ///http://stocksearching.us-west-2.elasticbeanstalk.com/stockProcess.php?symbolDetail=
        let baseURL = "http://localhost/stock_search/stockProcess.php?symbolDetail="
        let absolutePath = baseURL + symbol
        return NSURL(string: absolutePath)!
    }
    
    class func getNews(symbol: String) ->NSURL
    {
        let baseURL = "http://localhost/stock_search/stockProcess.php?news="
        let absolutePath = baseURL + symbol
        return NSURL(string: absolutePath)!
    }
    
    class func companyLookup(symbol: String) ->NSURL
    {
        let baseURL = "http://localhost/stock_search/stockProcess.php?symbol="
        let absolutePath = baseURL + symbol
        return NSURL(string: absolutePath)!
    }
}