//
//  AccelManager.swift
//  Tapir
//
//  Created by Chloe Baker on 1/23/16.
//  Copyright © 2016 CBaker. All rights reserved.
//

import Foundation
import CoreMotion

class AccelManager: NSObject {
    
    var manager = CMMotionManager()
    
    let algorithm = Algorithm()
    var accelData = [AccelData]()
    var isRunning = false

    
    func start() {
        isRunning = true
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "processData:", userInfo:  nil, repeats: true)
        
        algorithm.start()
        
        manager.deviceMotionUpdateInterval = Double(0.01)
        
        if !manager.deviceMotionActive {
            let queue = NSOperationQueue.currentQueue()
            manager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical, toQueue: queue!, withHandler: {
                
                (data:CMDeviceMotion?, error:NSError?) in
                
                let newUserAccel = self.adjustUserAccel(data!)
                let transfer = AccelData()
                transfer.x = newUserAccel.x
                transfer.y = newUserAccel.y
                transfer.z = newUserAccel.z
                self.accelData.append(transfer)
                //print(transfer.z, "zdata")
                
            })
        }
    }
    
//    func mock() {
//        print("hi")
//    }
    
    func processData(timer: NSTimer) {
//        let testerVector = AccelData()
//        testerVector.x = 1.0
//        testerVector.y = 4.0
//        testerVector.z = 17.0
//        
//        var transferArray = [AccelData]()
//        
//        for _ in 0...4 {
//            transferArray.append(testerVector)
//        }
        
        if isRunning {
            algorithm.decisionTree(accelData) //actually send accel data
            print(accelData.count, " number of elements sent to process")
            self.accelData = [AccelData]()
        }
        else {
            timer.invalidate()
            print("accel timer stop")
        }
    }
    
    func stop() {
        manager.stopDeviceMotionUpdates()
        isRunning = false
        algorithm.stop()
        print("data collect stop")

    }
    
    func adjustUserAccel(data: CMDeviceMotion) -> CMAcceleration {
        
        var newUserAccel = CMAcceleration()
        
        newUserAccel.x = (data.userAcceleration.x*data.attitude.rotationMatrix.m11) + (data.userAcceleration.y*data.attitude.rotationMatrix.m12) + (data.userAcceleration.z*data.attitude.rotationMatrix.m13)
        newUserAccel.y = (data.userAcceleration.x*data.attitude.rotationMatrix.m21) + (data.userAcceleration.y*data.attitude.rotationMatrix.m22) + (data.userAcceleration.z*data.attitude.rotationMatrix.m23)
        newUserAccel.z = (data.userAcceleration.x*data.attitude.rotationMatrix.m31) + (data.userAcceleration.y*data.attitude.rotationMatrix.m32) + (data.userAcceleration.z*data.attitude.rotationMatrix.m33)
        
        return newUserAccel
    }

    
}

class AccelData {

    var x = 1.0
    var y = 1.0
    var z = 1.0
    
}