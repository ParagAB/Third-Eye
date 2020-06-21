//
//  ViewController.swift
//  Third Eve
//
//  Created by Prashuk Ajmera on 10/19/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit
import AVKit
import Vision
import Firebase
import Speech
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, SFSpeechRecognizerDelegate {
    
    let identifierLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var searchedWord = ""
    var flag = 0
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdentifierConfidenceLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Step 1 : get word from user
        recordAndRecognizeSpeech()
    }
    
    fileprivate func setupIdentifierConfidenceLabel() {
        view.addSubview(identifierLabel)
        identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        identifierLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
                if self.flag == 0 {
                    self.searchedWord = bestString
                    // Step 2 : camera setup
                    self.cameraSetup()
                    self.flag = 1
                }
            } else {
                print(error ?? "Error")
            }
        })
    }
    
    func cameraSetup() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        // Step 3 : Deep learning
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            if (firstObservation.identifier == self.searchedWord) {
                let speechSynthesizer = AVSpeechSynthesizer()
                let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Found")
                speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
                speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                speechSynthesizer.speak(speechUtterance)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            DispatchQueue.main.async {
                self.identifierLabel.text = "\(firstObservation.identifier) \(firstObservation.confidence * 100)"
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}

