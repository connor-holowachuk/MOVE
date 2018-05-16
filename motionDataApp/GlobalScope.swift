//
//  GlobalScope.swift
//  Move
//
//  Created by Connor Holowachuk on 2014-07-20.
//  Copyright (c) 2014 Connor Holowachuk. All rights reserved.
//

//imports
import SpriteKit
import CoreMotion
import AVFoundation

let runOnSimulator = true

var previousScene = Int()

let Scene_BeginingPlayScene = Int(0)
let Scene_MainMenu = Int(1)
let Scene_CalibrationInstructions = Int(2)
let Scene_Settings = Int(3)
let Scene_LeaderBoard = Int(4)
let Scene_badCalibrationScene = Int(5)
let Scene_inGame = Int(6)
let Scene_GameStoreMain = Int(10)


//Ground ref'd Axis Coordinates: [x, y, z]
var XAxisCoordinates: [Float] = [0, 0, 0]
var YAxisCoordinates: [Float] = [0, 0, 0]
var ZAxisCoordinates: [Float] = [0, 0, 0]

//previous axis acceleration readings; used in the stopband Butterworth filter
var preAccelX = Double(0.0)
var preAccelY = Double(0.0)
var preAccelZ = Double(0.0)

//multiplier of the acceleration data; determined from the stopband Butterworth filter
var filteredAccelX = Double(0.0)
var filteredAccelY = Double(0.0)
var filteredAccelZ = Double(0.0)

//final value of the acceleration as experinced from eavh axis
var finalAccelXVal = Double(0.0)
var finalAccelYVal = Double(0.0)
var finalAccelZVal = Double(0.0)

//average noise as experinced by the axis; datermined in calibration and remains contant thereafter
var xAverageNoiseFromCalibration = Double()
var yAverageNoiseFromCalibration = Double()
var zAverageNoiseFromCalibration = Double()

//average noise as experinced by all of the axis'; datermined in calibration and remains contant thereafter
var averageNoise = Double()

//difference of global minima and maxima noise as experinced by the x axis; datermined in calibration and remains contant thereafter
var noiseBandWidth = Double()

//the value of 1g as experinced by the device's internal accelerometer
var valueOfG = Double()

var averageXRotationalNoise = Double()
var averageYRotationalNoise = Double()
var averageZRotationalNoise = Double()

var averageXRotationalOffset = Double()
var averageYRotationalOffset = Double()
var averageZRotationalOffset = Double()

var preGyroX = Double()
var preGyroY = Double()
var preGyroZ = Double()

var filteredGyroX = Double()
var filteredGyroY = Double()
var filteredGyroZ = Double()

var finalGyroXVal = Double()
var finalGyroYVal = Double()
var finalGyroZVal = Double()

var rotationalNoiseBandwidth = Double()

//button pressed sound player
var buttonPressedSoundPlayer1:AVAudioPlayer = AVAudioPlayer()
var buttonPressedSoundPlayer1URL:NSURL = NSBundle.mainBundle().URLForResource("buttonPressBeep", withExtension: "m4a")

//declare colours
let blueColour = UIColor(hex: 0x00F2FF)
let greenColour = UIColor(hex: 0xBBE80C)
let redColour = UIColor(hex: 0xFE6666)
let purpleColour = UIColor(hex: 0x9B0CE8)
let yellowColour = UIColor(hex: 0xF5FE66)
let orangeColour = UIColor(hex: 0xFF6D0D)
let pinkColour = UIColor(hex: 0xFF5AC4)
let deepBlueColour = UIColor(hex: 0x3675FC)
let whiteColour = UIColor(hex: 0xFFFFFF)

let darkGreyColour = UIColor(hex: 0x302D2D)

//declare font names
let standardTextFont = "ArialHebrew"
let standardTextBoldFont = "Avenir-Heavy"
let bubbleTextFont = "GurmukhiMN-Bold"

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

let scaleDownAction = SKAction.scaleTo(CGFloat(0) , duration: 0.4)
let scaleUpAction = SKAction.scaleTo(CGFloat(4) , duration: 0.4)
let scaleUpActionLabels = SKAction.scaleTo(CGFloat(1), duration: 0.44)
let scaleUpActionBubble = SKAction.scaleTo(CGFloat(0.24), duration: 0.44)
let scaleUpActionMedBubble = SKAction.scaleTo(CGFloat(0.5), duration: 0.44)


