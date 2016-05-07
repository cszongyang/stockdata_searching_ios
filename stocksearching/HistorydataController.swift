//
//  HistorydataController.swift
//  stock
//
//  Created by zongyang li on 4/23/16.
//  Copyright © 2016 Frank Lee. All rights reserved.
//

import UIKit

class HistorydataController: UIViewController {
    
    var symbol:String = ""
    
    @IBOutlet weak var hisBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var label: UILabel!
    
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
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
        // Do any additional setup after loading the view.
        hisBtn.selected = true
        print(DataStorage.stockDetailData)
       // label.text = DataStorage.symbol
        print(DataStorage.symbol)
        
        let url = NSURL(string: "http://localhost/stock_search/historyChart.php?symbol=" + DataStorage.symbol)!
        let request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }


}
