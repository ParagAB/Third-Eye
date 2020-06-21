//
//  ViewController.swift
//  Text-to-speech
//
//  Created by Prashuk Ajmera on 10/19/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var speechTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func recognizationSpeech() {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speechTextField.text!)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }

    @IBAction func tapToSpeak(_ sender: Any) {
        recognizationSpeech()
    }
    
}

