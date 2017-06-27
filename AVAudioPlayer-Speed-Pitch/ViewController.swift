//
//  ViewController.swift
//  AVAudioPlayer-Speed-Pitch
//
//  Created by Arved Viehweger on 27.06.17.
//  Copyright © 2017 Arved Viehweger. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {
    
    
    // initialize the speed slider
    @IBOutlet weak var speedSlider: UISlider!
    
    // initialize the pitch slider
    @IBOutlet weak var pitchSlider: UISlider!
    
    // initializing aa audio player node
    var audioPlayerNode : AVAudioPlayerNode!
    
    // initializing an audio engine
    var audioPlayerEngine : AVAudioEngine!
    
    // inittializing an audio file
    var audioPlayFile : AVAudioFile!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the minimum and maximum values, those can be more or less than my example values.
        
        speedSlider.minimumValue = 0.5
        speedSlider.maximumValue = 2.0
        speedSlider.value = 1.0
        
        pitchSlider.minimumValue = -2400.0
        pitchSlider.maximumValue = 2400.0
        pitchSlider.value = 0
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function to play the sound
    
    func playSound (speed: Float, pitch: Float, sound: String) {
        
        audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerEngine = AVAudioEngine()
        
        // you can replace mp3 with anything else you like, just make sure you load it from our project
        
        let soundFile = NSURL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!)
        
        audioPlayFile = try! AVAudioFile(forReading: soundFile as URL)
        
        // making sure to clean up the audio hardware to avoid any damage and bugs
        
        audioPlayerNode.stop()
        
        audioPlayerEngine.stop()
        
        audioPlayerEngine.reset()
        
        audioPlayerEngine.attach(audioPlayerNode)
        
        let audioUnit = AVAudioUnitTimePitch()
        
        // assign the speed and pitch
        
        audioUnit.pitch = pitch
        
        audioUnit.rate = speed
        
        audioPlayerEngine.attach(audioUnit)
        
        audioPlayerEngine.connect(audioPlayerNode, to: audioUnit, format: nil)
        
        audioPlayerEngine.connect(audioUnit, to: audioPlayerEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioPlayFile, at: nil, completionHandler: nil)
        
        // try to start playing the audio
        
        do {
            try audioPlayerEngine.start()
        } catch {
            print(error)
        }
        
        // play the audio
        
        audioPlayerNode.play()
        
    }

    @IBAction func playSound(_ sender: Any) {
        
        // demoSound is the name of your audio file without dot and extension
        
        playSound(speed: speedSlider.value, pitch: pitchSlider.value, sound: "demoSound")
        
    }

}

