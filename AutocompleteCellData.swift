//
//  AutocompleteCellData.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/12/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

//public protocol AutocompletableOption {
//  //  var text: String { get }
//    var text: String { get }
//}
//
//public class AutocompleteCellData: AutocompletableOption {
////    private let _text: String
////    public var text: String { get { return _text } }
////    public let image: UIImage?
////    
//    public let text: String
//    private let Name: String
//    private let Exchange: String
//
//
//    public init(text: String, Name: String, Exchange: String) {
//        self.Name = Name
//        self.Exchange = Exchange
//        self.text = text
//    }
//}
public protocol AutocompletableOption {
    var text: String { get }
    var symbolValue: String { get }
}

public class AutocompleteCellData: AutocompletableOption {
    private let _text: String
    private let _symbolValue: String
    public var text: String { get { return _text } }
    public let image: UIImage?
    
    public var symbolValue: String { get { return _symbolValue } }
    
    public init(text: String, image: UIImage?, symbolValue: String) {
        self._text = text
        self.image = image
        self._symbolValue = symbolValue
    }
}