//
//  ViewController.swift
//  Speech-to-text
//
//  Created by Prashuk Ajmera on 10/19/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

     @IBOutlet weak var detectedText: UILabel!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormate = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormate) { (buffer, _ ) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                print(bestString)
                self.detectedText.text = bestString
            } else {
                print(error ?? "Error")
            }
        })
    }
    
    @IBAction func tapToRecord(_ sender: Any) {
        recordAndRecognizeSpeech()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        audioEngine.stop()
    }
    
}

