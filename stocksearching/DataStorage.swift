//
//  DataStorage.swift
//  stock
//
//  Created by zongyang li on 5/1/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import Foundation

class DataStorage  {
    static var symbol:String = ""
    static var flag: Bool = false
    static var stockDetailData:[(String,String)] = []
    static var newsArray: [(String,String,String,String,String)] = []
    static var favoriteSymbols: [String] = []
    static var isExistedinFavList: Bool = false
    static var existInfavorite: Bool = false
    
    
    

    
    func clearData() {
       // self.symbol = ""
    }
}