//
//  Algorithm.swift
//  Tapir
//
//  Created by Chloe Baker on 1/23/16.
//  Copyright © 2016 CBaker. All rights reserved.
//

import Foundation
import CoreMotion

class Algorithm: NSObject {
    
    var isDone = true
    var results = ["isItMe":0, "probability":0, "timeThing":0]
    var timerIncrement = 1
    var isRunning = false
    
    var arrayProb = [0, 0, 0]
    var index = 0
    
    var arrayAsND = ndarray(n:1000)

    var spec = [Double]()

    var mag = [Double]()
    
    var saveData = ""
    
    func start() {
        NSTimer.scheduledTimerWithTimeInterval(Double(timerIncrement), target: self, selector: "notify:",
            userInfo: nil, repeats: true)
        isRunning = true
    }
    
    func stop() {
        isRunning = false
        saveToFile()
    }
    
    func decisionTree(accelData: [AccelData]) {
        
        var accelDatax = [Double]()
        var accelDatay = [Double]()
        var accelDataz = [Double]()

        for i in 0...accelData.count-1 {
            accelDatax.append(accelData[i].x)
            accelDatay.append(accelData[i].y)
            accelDataz.append(accelData[i].z)
        }
        
        var sumx = 0.0
        var sumy = 0.0
        var sumz = 0.0
        
        for i in 0...accelData.count-1 {
            sumx += accelDatax[i]
            sumy += accelDatay[i]
            sumz += accelDataz[i]
        }
        
        let meanx = sumx/accelDatax.count
        let meany = sumy/accelDatay.count
        let meanz = sumz/accelDataz.count
        
        for i in 0...accelData.count-1 {
            accelDatax[i] -= meanx
            accelDatay[i] -= meany
            accelDataz[i] -= meanz
        }
        
        for i in 0...accelData.count-1 {
           mag.append(sqrt(pow(accelDatax[i], 2) + pow(accelDatay[i], 2) + pow(accelDataz[i], 2)))
        }
        
        let nearestPowerOfTwo = log2(Double(mag.count))
        
        if (nearestPowerOfTwo != Int(nearestPowerOfTwo)) {
            let roundUp = ceil(nearestPowerOfTwo)
            for _ in 0...(pow(2, roundUp)-mag.count-1) {
                mag.append(0)
            }
        }
    
        let magArrayAsND = asarray(mag)
        let fftArray = fft(magArrayAsND)
        var fftmag = [Double]()
        let real = fftArray.0.grid
        let imaginary = fftArray.1.grid
        
        for i in 0...49 {
            fftmag.append(sqrt(pow(real[i], 2) + pow(imaginary[i], 2)))
        }
        
        let dynamicRangex = accelDatax.maxElement()! - accelDatax.minElement()!
        let dynamicRangey = accelDatay.maxElement()! - accelDatay.minElement()!
        let dynamicRangez = accelDataz.maxElement()! - accelDataz.minElement()!
        
        let dynamicRange = sqrt(pow(dynamicRangex, 2) + pow(dynamicRangey, 2) + pow(dynamicRangez, 2))
        
        fftmag.append(dynamicRange)
        
        print(mag, " ", fftmag)
        
        var isItMe = 0
        
        if (fftmag[11] <= 15.13072 || fftmag[12] <= 15.13072 || fftmag[10] <= 15.13072) {
            isItMe = 0
        }
        else if (fftmag[11] > 15.13072 || fftmag[12] > 15.13072 || fftmag[10] > 15.13072)  {
            if (fftmag[34] > 8.235573 || fftmag[35] > 8.235573 || fftmag[33] > 8.235573)  {
                isItMe = 0
            }
            else if (fftmag[34] <= 8.235573 || fftmag[35] <= 8.235573 || fftmag[33] <= 8.235573) {
                if (fftmag[12] > 21.53571 || fftmag[13] > 21.53571 || fftmag[11] > 21.53571) {
                    if (fftmag[50] <= 4.572018 || fftmag[51] <= 4.572018 || fftmag[49] <= 4.572018) {
                        isItMe = 1
                    }
                    else if (fftmag[50] > 4.572018 || fftmag[51] > 4.572018 || fftmag[49] > 4.572018) {
                        isItMe = 0
                    }
                }
                else if (fftmag[12] <= 21.53571 || fftmag[13] <= 21.53571 || fftmag[11] <= 21.53571) {
                    if (fftmag[11] > 34.6322 || fftmag[12] > 34.6322 || fftmag[10] > 34.6322) {
                        if (fftmag[48] <= 4.11653 || fftmag[49] <= 4.11653 || fftmag[47] <= 4.11653) {
                            isItMe = 0
                        }
                        else if (fftmag[48] > 4.11653 || fftmag[49] > 4.11653 || fftmag[47] > 4.11653) {
                            isItMe = 1
                        }
                    }
                    else if (fftmag[11] <= 34.6322 || fftmag[12] <= 34.6322 || fftmag[10] <= 34.6322) {
                        if (fftmag[48] <= 8.437315 || fftmag[49] <= 8.437315 || fftmag[47] <= 8.437315) {
                            if (fftmag[28] <= 13.74777 || fftmag[29] <= 13.74777 || fftmag[27] <= 13.74777) {
                                isItMe = 0
                            }
                            else if (fftmag[28] > 13.74777 || fftmag[29] > 13.74777 || fftmag[27] > 13.74777) {
                                if (fftmag[5] <= 31.66546 || fftmag[6] <= 31.66546 || fftmag[4] <= 31.66546) {
                                    isItMe = 0
                                }
                                else if (fftmag[5] > 31.66546 || fftmag[6] > 31.66546 || fftmag[4] > 31.66546) {
                                    isItMe = 1
                                }
                            }
                        }
                        else if (fftmag[48] > 8.437315 || fftmag[49] > 8.437315 || fftmag[47] > 8.437315) {
                            if fftmag[0] > 215.508  {
                                isItMe = 0
                            }
                            else if fftmag[0] <= 215.508 {
                                if (fftmag[38] <= 9.143097 || fftmag[39] <= 9.143097 || fftmag[37] <= 9.143097) {
                                    isItMe = 1
                                }
                                else if (fftmag[38] > 9.143097 || fftmag[39] > 9.143097 || fftmag[37] > 9.143097) {
                                    isItMe = 0
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.saveData = self.saveData.stringByAppendingString("\(results["timeThing"]), \(isItMe)\n")
        mag = [Double]()
        calcMean(isItMe)
    }

    
    
//    func kNN(accelData: [AccelData]) {
//        print(accelData[0], "data passed")
//        isDone = true
//        let probability = arc4random()%100
//        var result = 0
//        
//        if probability>=25 {
//            result = 1
//        }
//        else {
//            result = 0
//        }
//        calcMean(result)
//    }
    
    
    func calcMean(result: Int) {
        var meanProb = 0.0
        
        arrayProb[index] = result
        index++
        
        if index>2 {
            index=0
        }
        
        meanProb = Double((arrayProb[0] + arrayProb[1] + arrayProb[2]))/3.0
        print(meanProb, "mean prob")
        results["probability"] = Int((meanProb) * 100)
        
        if meanProb>=0.5 {
            results["isItMe"] = 1
        }
        else {
            results["isItMe"] = 0
        }

    }
    
    func notify(timer: NSTimer) {
        if isDone && isRunning {
            NSNotificationCenter.defaultCenter().postNotificationName("updateReady", object: self, userInfo: results)
            results["timeThing"]! += timerIncrement
        }
        else {
            timer.invalidate()
            print("alg timer stopped")
        }
    }
    
    func saveToFile() {
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "mm_ss"
        let displayString = formatter.stringFromDate(currentTime)
        
        let fileManager = NSFileManager()
        let docsDir = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
        let path = docsDir!.URLByAppendingPathComponent("result\(displayString).csv")
        print("began write, \(NSDate())")
        do {
            try saveData.writeToURL(path, atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
        }

    }
}
