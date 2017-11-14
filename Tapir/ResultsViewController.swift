//
//  ResultsViewController.swift
//  Tapir
//
//  Created by Chloe Baker on 1/23/16.
//  Copyright © 2016 CBaker. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var accelManager = AccelManager()
    
    @IBOutlet weak var validStatement: UILabel!
        
    @IBAction func stopButton(sender: AnyObject) {
        accelManager.stop()
    }
    
    @IBOutlet weak var probableStatement: UILabel!
        
    @IBOutlet weak var timeStatement: UILabel!
    
    
    func displayData(notification: NSNotification) {
        
        let upData = notification.userInfo as! [String:Int]
        
        if upData["isItMe"] == 1 {
            validStatement.text = "You are a valid user"
        }
        else {
            validStatement.text = "You are not a valid user"
        }
        
        probableStatement.text = "\(upData["probability"]!)%"
        timeStatement.text = ("based on \(upData["timeThing"]!) seconds of recording")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayData:",
            name: "updateReady", object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation 
        before navigation
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
