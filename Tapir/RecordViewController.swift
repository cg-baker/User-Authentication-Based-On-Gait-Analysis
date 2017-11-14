//
//  RecordViewController.swift
//  Tapir
//
//  Created by Chloe Baker on 1/19/16.
//  Copyright © 2016 CBaker. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class RecordViewController: UIViewController, UITextFieldDelegate {
    
    var accelManager = AccelManager()
    
    @IBOutlet var label: UILabel!
    @IBAction func startRecording(sender: UIButton) {
            accelManager.start()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
//        var specx = [Double]()
//        
//        var anArray = [1.0,2.0,4,5]
//        
//        for _ in 0...(256-anArray.count-1) {
//            anArray.append(0)
//        }
//        
//        let arrayAsNDx = asarray(anArray)
//
//        
//        let fftx = fft(arrayAsNDx)
//        let realx = fftx.0.grid
//        let imaginex = fftx.1.grid
//        print(fftx)
//
//        
//        
//        for i in 0...3 {
//            specx.append((pow(realx[i], 2) + (pow(imaginex[i], 2)))/17)
//        }
//        
//        print(specx)
        

//        
//        let x = array(0,1,1,1,0)
//        let y = fft(x)
//        let real = y.0.grid
//        let img = y.1.grid
//        var multiply = [Double]()
//        print(real.count)
//        for i in 0...(real.count-1) {
//            multiply.append(y.0[i]*y.1[i])
//            
//        }
//        print(multiply)
//        print (real)
//        print(img)
//        print(x)
//        print(y)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSegue" {
            if let destinationVC = segue.destinationViewController as? ResultsViewController {
                destinationVC.accelManager = self.accelManager
            }
        }
        
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }


}
