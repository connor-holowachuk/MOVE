//
//  CalibrateScene.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-18.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

import SpriteKit
import CoreMotion

class CalibrateScene: SKScene {
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    var calibratingLabelHeading = SKLabelNode(fontNamed: standardTextFont)
    
    var timesRunThrough = Int(0)
    var maxCalibrationFramesRunThrough = 744
    
    var stageOfCalibration: Int = 0
    
    var loading20Image = SKSpriteNode(imageNamed: "loading20Image")
    var loading40Image = SKSpriteNode(imageNamed: "loading40Image")
    var loading60Image = SKSpriteNode(imageNamed: "loading60Image")
    var loading80Image = SKSpriteNode(imageNamed: "loading80Image")
    var loading100Image = SKSpriteNode(imageNamed: "loading100Image")
    
    var backgroundImage = SKSpriteNode(imageNamed: "backgroundImage")

    override func didMoveToView(view: SKView!){
        
        backgroundImage.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        backgroundImage.setScale(0.5)
        backgroundImage.zPosition = -4
        self.addChild(backgroundImage)
        
        //setup the label
        calibratingLabelHeading.position = CGPointMake(self.frame.width / 2, self.frame.height * (2 / 3))
        calibratingLabelHeading.zPosition = CGFloat(2)
        calibratingLabelHeading.fontColor = deepBlueColour
        calibratingLabelHeading.fontSize = CGFloat(36)
        calibratingLabelHeading.text = "calibrating..."
        self.addChild(calibratingLabelHeading)
        
        let loadingImagesPosition = CGPointMake(self.frame.width / 2, self.frame.height / 3)
        
        loading20Image.position = loadingImagesPosition
        loading40Image.position = loadingImagesPosition
        loading60Image.position = loadingImagesPosition
        loading80Image.position = loadingImagesPosition
        loading100Image.position = loadingImagesPosition
        loading20Image.setScale(0.5)
        loading40Image.setScale(0.5)
        loading60Image.setScale(0.5)
        loading80Image.setScale(0.5)
        loading100Image.setScale(0.5)
        self.addChild(loading20Image)
    }
    
    func goodCalibration(){
        let moveOutAction = SKAction.moveToX(0 - self.frame.width / 2, duration: 0.44)
        loading100Image.runAction(moveOutAction)
        calibratingLabelHeading.runAction(moveOutAction)
        delay(0.744){
            var pauseOutgoingscene = false
            let scene = goodCalibrationScene(size: self.scene.size)
            let skView = self.view as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = SKSceneScaleMode.AspectFill
            scene.size = skView.bounds.size
            self.scene.view.presentScene(scene)
        }
    }
    
    func badCalibration(){
        println("bad calibration!")
        var pauseOutgoingscene = true
        let scene = badCalibrationScene(size: self.scene.size)
        let skView = self.view as SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.size = skView.bounds.size
        self.scene.view.presentScene(scene)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    //CALIBRATION STAGES BEGIN
    
    //CALIBRATION STAGE 0:
    //determine the average noise experienced by each of the 3 read axis
    func gatherAccelerometerAverageNoise() -> (xAverageNoise: Double, yAverageNoise: Double, zAverageNoise: Double, differenceInNoise: Double){
        
        //declare variables to be used in this stage of calibration in the below accelerometer read portion
        var xAverageNoise = Double(), yAverageNoise = Double(), zAverageNoise = Double()
        var currentXNoise = Double(), currentYNoise = Double(), currentZNoise = Double()
        var prevXNoise = Double(0.002189), prevYNoise = Double(0.002189), prevZNoise = Double(0.002189)
        var prevXVal = Double(0.0), prevYVal = Double(0.0), prevZVal = Double(0.0)
        
        //declare global minima and maxima values to initially be previously determined value
        var minimumNoise = Double(0.002189)
        var maximumNoise = Double(0.002189)
        
        //declare variables that are required to keep the below accelerometer loop running / stop the loop
        var cyclesThroughFindingNoise: Int = 2
        var keepFindingAverageNoise = true
        
        println("motion management begins")
        
        if (motionManager.accelerometerAvailable) {
            while keepFindingAverageNoise == true{
                motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    
                    //sets initial average noises to predetermined average noise value; values hereafter will be mathematically calculated
                    if cyclesThroughFindingNoise == 2{
                        xAverageNoise = 0.002189
                        yAverageNoise = 0.002189
                        zAverageNoise = 0.002189
                    }else{
                        xAverageNoise = abs(data.acceleration.x - prevXVal)
                        yAverageNoise = abs(data.acceleration.y - prevYVal)
                        zAverageNoise = abs(data.acceleration.z - prevZVal)
                    }
                    
                    //moving average filter for each three of the axis average noise value
                    currentXNoise = (xAverageNoise + (Double(cyclesThroughFindingNoise - 1) * prevXNoise)) / Double(cyclesThroughFindingNoise)
                    currentYNoise = (yAverageNoise + (Double(cyclesThroughFindingNoise - 1) * prevYNoise)) / Double(cyclesThroughFindingNoise)
                    currentZNoise = (zAverageNoise + (Double(cyclesThroughFindingNoise - 1) * prevZNoise)) / Double(cyclesThroughFindingNoise)
                    
                    //calulate the global minima and maxima of the noise values
                    if xAverageNoise < minimumNoise{
                        minimumNoise = xAverageNoise
                    }
                    if xAverageNoise > maximumNoise{
                        maximumNoise = xAverageNoise
                    }
                    
                    //set current accelerometer data to be the previous accelerometer data in the next loop run
                    prevXVal = (data.acceleration.x)
                    prevYVal = (data.acceleration.y)
                    prevZVal = (data.acceleration.z)

                    //set current noise data to be the previous noise data in the next loop run
                    prevXNoise = currentXNoise
                    prevYNoise = currentYNoise
                    prevZNoise = currentZNoise
                    
                    //allows the system to stop excecuting this section of the calibration stage after the below number of cycles
                    if cyclesThroughFindingNoise > 544{
                        keepFindingAverageNoise = false
                    }

                    //advance the number of cycle run throughs by 1 for the next loop run
                    cyclesThroughFindingNoise++

                    //println("\(prevXNoise), \(prevYNoise), \(prevZNoise), \(cyclesThroughFindingNoise)")
                    
                    self.motionManager.accelerometerActive == true
                }
            }
            //stop the readings of the acceleromter
            motionManager.stopAccelerometerUpdates()
        }
        
        //manipulate the above data to determine the difference in noise and the average noise
        var differenceInNoise = maximumNoise - minimumNoise
        averageNoise = (prevXNoise + prevYNoise + prevZNoise) / 3
        
        //manipulate the above data to determine the average noise of each axis, weighted 50% by the average noise
        xAverageNoise = (prevXNoise + averageNoise) / 2
        yAverageNoise = (prevYNoise + averageNoise) / 2
        zAverageNoise = (prevZNoise + averageNoise) / 2
        
        println("the difference in noise is: \(differenceInNoise)")
        
        //return the obtained data
        return (xAverageNoise, yAverageNoise, zAverageNoise, differenceInNoise)
    }
    
    //CALIBRATION STAGE 1: (two procedures)
    //determine the device's perception of 1g, as well as determine the initial z-value of eavh axis on the ground ref'd coordinate system
    func gatherValueOfG(xAxisAverageNoise: Double, yAxisAverageNoise: Double, zAxisAverageNoise: Double, noiseBW: Double) -> (valueOfG: Double, xAccleeration: Double, yAccleeration: Double, zAccleeration: Double){
        var xAcceleration = Double(), yAcceleration = Double(), zAcceleration = Double()
        var keepFindingAverageG = true
        var cyclesThroughFindingG: Int = 2
        var currentG = Double(1)
        var prevG = Double(1)

        if (motionManager.accelerometerAvailable) {
            while keepFindingAverageG == true{
                motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    
                    filteredAccelX = Double(-1.0 / sqrt(1.0 + pow((((data.acceleration.x - preAccelX) - xAxisAverageNoise) / noiseBW), 8))) + 1
                    filteredAccelY = Double(-1.0 / sqrt(1.0 + pow((((data.acceleration.y - preAccelY) - yAxisAverageNoise) / noiseBW), 8))) + 1
                    filteredAccelZ = Double(-1.0 / sqrt(1.0 + pow((((data.acceleration.z - preAccelZ) - zAxisAverageNoise) / noiseBW), 8))) + 1
                    
                    finalAccelXVal = (data.acceleration.x * filteredAccelX) + ((1 - filteredAccelX) * preAccelX)
                    finalAccelYVal = (data.acceleration.y * filteredAccelY) + ((1 - filteredAccelY) * preAccelY)
                    finalAccelZVal = (data.acceleration.z * filteredAccelZ) + ((1 - filteredAccelZ) * preAccelZ)

                    self.motionManager.accelerometerActive == true
                    
                    valueOfG = sqrt(pow(finalAccelXVal, 2) + pow(finalAccelYVal, 2) + pow(finalAccelZVal, 2))
                    
                    currentG = (valueOfG + (Double(cyclesThroughFindingG - 1) * prevG)) / Double(cyclesThroughFindingG)
                    
                    preAccelX = finalAccelXVal
                    preAccelY = finalAccelYVal
                    preAccelZ = finalAccelZVal
                    prevG = currentG
                    
                    //println("\(preAccelX - (preAccelX % 0.0001)), \(preAccelY - (preAccelY % 0.0001)), \(preAccelZ - (preAccelZ % 0.0001))")
                    
                    if(cyclesThroughFindingG > 344){
                        keepFindingAverageG = false
                    }
                    cyclesThroughFindingG++
                }
            }
            motionManager.stopAccelerometerUpdates()
        }
        xAcceleration = preAccelX
        yAcceleration = preAccelY
        zAcceleration = preAccelZ

        currentG = valueOfG
        return (valueOfG, xAcceleration, yAcceleration, zAcceleration)
    }
    
    //CALIBRATION STAGE 2:
    //determine the gyroscope's average noise as experienced by each of the axis
    func calibrateGyroscope() -> (currentXRotationNoise: Double, currentYRotationNoise: Double, currentZRotationNoise: Double){
        
        //declare variables to be used in this stage of calibration in the below accelerometer read portion
        var xRotationAverageNoise = Double(), yRotationAverageNoise = Double(), zRotationAverageNoise = Double()
        var currentXRotationNoise = Double(), currentYRotationNoise = Double(), currentZRotationNoise = Double()
        var prevXRotationNoise = Double(0.002189), prevYRotationNoise = Double(0.002189), prevZRotationNoise = Double(0.002189)
        var prevXRotationVal = Double(0.0), prevYRotationVal = Double(0.0), prevZRotationVal = Double(0.0)
        
        var xRotation = Double()
        var yRotation = Double()
        var zRotation = Double()
        
        var keepFindingGyroData = true
        var cyclesThroughFindingGyroData = Int(2)
        
        var minimumNoise = Double(0.0014)
        var maximumNoise = Double(0.0014)
        
        if (motionManager.gyroAvailable) {
            
            while keepFindingGyroData == true{
                motionManager.startGyroUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    
                    xRotation = data.rotationRate.x
                    yRotation = data.rotationRate.y
                    zRotation = data.rotationRate.z
                    
                    if cyclesThroughFindingGyroData == 2{
                        xRotationAverageNoise = 0.002189
                        yRotationAverageNoise = 0.002189
                        zRotationAverageNoise = 0.002189
                    }else{
                        xRotationAverageNoise = abs(xRotation - prevXRotationVal)
                        yRotationAverageNoise = abs(yRotation - prevYRotationVal)
                        zRotationAverageNoise = abs(zRotation - prevZRotationVal)
                    }
                    
                    currentXRotationNoise = (xRotationAverageNoise + (Double(cyclesThroughFindingGyroData - 1) * prevXRotationNoise)) / Double(cyclesThroughFindingGyroData)
                    currentYRotationNoise = (yRotationAverageNoise + (Double(cyclesThroughFindingGyroData - 1) * prevYRotationNoise)) / Double(cyclesThroughFindingGyroData)
                    currentZRotationNoise = (zRotationAverageNoise + (Double(cyclesThroughFindingGyroData - 1) * prevZRotationNoise)) / Double(cyclesThroughFindingGyroData)
                    
                    prevXRotationVal = xRotation
                    prevYRotationVal = yRotation
                    prevZRotationVal = zRotation
                    
                    prevXRotationNoise = currentXRotationNoise
                    prevYRotationNoise = currentYRotationNoise
                    prevZRotationNoise = currentZRotationNoise
                    
                    if xRotationAverageNoise < minimumNoise{
                        minimumNoise = xRotationAverageNoise
                    }
                    if xRotationAverageNoise > maximumNoise{
                        maximumNoise = xRotationAverageNoise
                    }
                    
                    //println("\(currentXRotationNoise), \(currentYRotationNoise), \(currentZRotationNoise)")
                    
                    if(cyclesThroughFindingGyroData > 444){
                        keepFindingGyroData = false
                    }
                    cyclesThroughFindingGyroData++
                    self.motionManager.gyroActive == true
                }
            }
            motionManager.stopGyroUpdates()
        }
        var averageRotationalNoise = (currentXRotationNoise + currentYRotationNoise + currentZRotationNoise) / 3
        
        currentXRotationNoise = (currentXRotationNoise + averageRotationalNoise) / 2
        currentYRotationNoise = (currentYRotationNoise + averageRotationalNoise) / 2
        currentZRotationNoise = (currentZRotationNoise + averageRotationalNoise) / 2
        
        rotationalNoiseBandwidth = maximumNoise - minimumNoise
        
        return(currentXRotationNoise, currentYRotationNoise, currentZRotationNoise)
    }
    
    //CALIBRATION STAGE 3:
    //determine the offset required to zero reference the gyroscope's readings as experienced by all three axis
    func determineOffsetOfGyroData(xAxisAverageRotationalNoise: Double, yAxisAverageRotationalNoise: Double, zAxisAverageRotationalNoise: Double) -> (xOffset: Double, yOffset: Double, zOffset: Double){
        
        var xOffset = Double(), yOffset = Double(), zOffset = Double()
        var keepFindingGyroData = true
        var cyclesThroughFindingGyroData = Int(2)
        
        if (motionManager.gyroAvailable) {
            
            while keepFindingGyroData == true{
                motionManager.startGyroUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    
                    filteredGyroX = Double(-1.0 / sqrt(1.0 + pow((((data.rotationRate.x - preGyroX) - xAxisAverageRotationalNoise) / rotationalNoiseBandwidth), 8))) + 1
                    filteredGyroY = Double(-1.0 / sqrt(1.0 + pow((((data.rotationRate.y - preGyroY) - yAxisAverageRotationalNoise) / rotationalNoiseBandwidth), 8))) + 1
                    filteredGyroZ = Double(-1.0 / sqrt(1.0 + pow((((data.rotationRate.z - preGyroZ) - zAxisAverageRotationalNoise) / rotationalNoiseBandwidth), 8))) + 1
                    
                    finalGyroXVal = (data.rotationRate.x * filteredGyroX) + ((1 - filteredGyroX) * preGyroX)
                    finalGyroYVal = (data.rotationRate.y * filteredGyroY) + ((1 - filteredGyroY) * preGyroY)
                    finalGyroZVal = (data.rotationRate.z * filteredGyroZ) + ((1 - filteredGyroZ) * preGyroZ)
                    
                    preGyroX = finalGyroXVal
                    preGyroY = finalGyroYVal
                    preGyroZ = finalGyroZVal
                    
                    //println("\(preGyroX), \(preGyroY), \(preGyroZ)")
                    
                    if(cyclesThroughFindingGyroData > 244){
                        keepFindingGyroData = false
                    }
                    
                    cyclesThroughFindingGyroData++
                    
                    self.motionManager.gyroActive == true
                    
                }
            }
            motionManager.stopGyroUpdates()
        }
        xOffset = preGyroX
        yOffset = preGyroY
        zOffset = preGyroZ
        
        return(xOffset, yOffset, zOffset)
    }
    
    //update data at begining of scene render
    override func update(currentTime: CFTimeInterval) {
        
        let moveOutAction = SKAction.moveToX(self.frame.width * (3 / 2), duration: 0.44)
        
        if timesRunThrough > 74{
            if runOnSimulator == true{
                println("IM HERE!!!!")
                goodCalibration()
                timesRunThrough = 0
            }else{
                //call and react on stage zero of calibration
                if stageOfCalibration == 0{
                    
                    println("at stage 0 of calibration")
                    var accelerometerValue = gatherAccelerometerAverageNoise()
                    xAverageNoiseFromCalibration = accelerometerValue.xAverageNoise
                    yAverageNoiseFromCalibration = accelerometerValue.yAverageNoise
                    zAverageNoiseFromCalibration = accelerometerValue.zAverageNoise
                    noiseBandWidth = accelerometerValue.differenceInNoise
                    
                    println("\(accelerometerValue.xAverageNoise), \(accelerometerValue.yAverageNoise), \(accelerometerValue.zAverageNoise)")
                    if averageNoise > 0.0028 || averageNoise < 0.0016{
                        calibratingLabelHeading.runAction(moveOutAction)
                        self.loading20Image.runAction(moveOutAction)
                        delay(0.744){
                            self.badCalibration()
                        }
                        stageOfCalibration = 44
                    }else{
                        self.loading20Image.removeFromParent()
                        self.addChild(loading40Image)
                        stageOfCalibration++
                    }
                    
                //call and react on stage one of calibration
                }else if stageOfCalibration == 1{
                    
                    println("at stage 1 of calibration")
                    var secondStageOfCalibration = gatherValueOfG(xAverageNoiseFromCalibration, yAxisAverageNoise: yAverageNoiseFromCalibration, zAxisAverageNoise: zAverageNoiseFromCalibration, noiseBW: noiseBandWidth)
                    
                    valueOfG = secondStageOfCalibration.valueOfG
                    println("the value of G is: \(valueOfG)")
                    
                    XAxisCoordinates[2] = Float(secondStageOfCalibration.xAccleeration)
                    YAxisCoordinates[2] = Float(secondStageOfCalibration.yAccleeration)
                    ZAxisCoordinates[2] = Float(secondStageOfCalibration.zAccleeration)
                    
                    if valueOfG > 1.014 || valueOfG < 0.94{
                        self.loading40Image.runAction(moveOutAction)
                        calibratingLabelHeading.runAction(moveOutAction)
                        delay(0.744){
                            self.badCalibration()
                        }
                        stageOfCalibration = 44
                    }else{
                        println("calibration is valid so far...")
                        self.loading40Image.removeFromParent()
                        self.addChild(loading60Image)
                        stageOfCalibration++
                    }
                    
                //call and react on stage two of calibration
                }else if stageOfCalibration == 2{
                    var calibrationValues = calibrateGyroscope()
                    averageXRotationalNoise = calibrationValues.currentXRotationNoise
                    averageYRotationalNoise = calibrationValues.currentYRotationNoise
                    averageZRotationalNoise = calibrationValues.currentZRotationNoise
                    println("final values are: \(averageXRotationalNoise), \(averageYRotationalNoise), \(averageZRotationalNoise)")
                    
                    if averageXRotationalNoise > 0.0018 || averageXRotationalNoise < 0.001{
                        self.loading60Image.runAction(moveOutAction)
                        calibratingLabelHeading.runAction(moveOutAction)
                        delay(0.744){
                            self.badCalibration()
                        }
                        stageOfCalibration = 44
                    }else{
                        println("calibration is valid so far...")
                        self.loading60Image.removeFromParent()
                        self.addChild(loading80Image)
                        stageOfCalibration++
                    }
                }else if stageOfCalibration == 3{
                    var calibrationValues = determineOffsetOfGyroData(averageXRotationalNoise, yAxisAverageRotationalNoise: averageYRotationalNoise, zAxisAverageRotationalNoise: averageZRotationalNoise)
                    averageXRotationalOffset = calibrationValues.xOffset
                    averageYRotationalOffset = calibrationValues.yOffset
                    averageZRotationalOffset = calibrationValues.zOffset
                    //println("final offsets are: \(averageXRotationalOffset), \(averageYRotationalOffset), \(averageZRotationalOffset)")
                    stageOfCalibration = 44
                    self.loading80Image.removeFromParent()
                    self.addChild(loading100Image)
                    goodCalibration()
                }
            }
            println("times run through: \(timesRunThrough)")
        }
        timesRunThrough++
    }
}