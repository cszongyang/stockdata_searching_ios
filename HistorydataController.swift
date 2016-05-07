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
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var label: UILabel!
    
    func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
        // Do any additional setup after loading the view.
        print(DataStorage.stockDetailData)
       // label.text = DataStorage.symbol
        print(DataStorage.symbol)
        
        let url = NSURL(string: "http://stocksearching.us-west-2.elasticbeanstalk.com/historyChart.php?symbol=" + DataStorage.symbol)!
        let request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.popToRootViewControllerAnimated(true)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
