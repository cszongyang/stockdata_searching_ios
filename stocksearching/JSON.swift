//
//  JSON.swift
//  stockSearch
//
//  Created by zongyang li on 4/20/16.
//  Copyright © 2016 zongyang li. All rights reserved.
//

import Foundation


/**
 Attempts to convert the specified data object to JSON data
 objects and returns either the root JSON object or an error.
 */
func JSONObjectWithData(data: NSData) throws
    -> NSDictionary
{
    return try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary

}