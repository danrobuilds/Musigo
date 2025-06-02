//
//  DisplayViewController.swift
//  UserInterface
//
//  Created by Daniel Rosario on 2/23/20.
//  Copyright © 2020 Daniel Rosario. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class DisplayViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var PieceNameList = [String()]
    var PieceList = [String]()
    var ChosenPiece = Int()
    var NameofPiece = ""
    
    var tiltTrueturnFalse = true
    var lookedRightorLeft = false;
    var areTherePages = true;
    
    
    
    @IBOutlet weak var PieceLabel: UILabel!
    
    
    
    @IBAction func HeadTiltPressed(_ sender: Any) {
        tiltTrueturnFalse = true
        TiltTurnViews()
    }
    
    @IBAction func HeadTurnPressed(_ sender: Any) {
        tiltTrueturnFalse = false
        TiltTurnViews()
    }
    
    @IBOutlet weak var HeadTiltView: UIView!
    
    @IBOutlet weak var HeadTurnView: UIView!
    
    
    
    
    func TiltTurnViews() {
        
        if tiltTrueturnFalse == true {
            HeadTiltView.layer.cornerRadius = HeadTiltView.frame.height / 4
            HeadTiltView.backgroundColor = UIColor.systemTeal
            HeadTurnView.backgroundColor = nil
        }
        else if tiltTrueturnFalse == false {
            HeadTurnView.layer.cornerRadius = HeadTurnView.frame.height / 4
            HeadTiltView.backgroundColor = nil
            HeadTurnView.backgroundColor = UIColor.systemTeal
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
    @IBOutlet weak var PieceDisplay: UIImageView!
    
        
    
       // var newjokeimage: UIImage?
        

        
        func getImage(imageName: String){
           let fileManager = FileManager.default
           let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
           if fileManager.fileExists(atPath: imagePath){
            DispatchQueue.main.async {
                self.PieceDisplay.image = UIImage(contentsOfFile: imagePath)
            }
           }
           else {
                print("Panic! No Image!")
                areTherePages = false
           }
            lookedRightorLeft = true
        }
        
        
       
        override func viewDidLoad() {
               super.viewDidLoad()
               // Do any additional setup after loading the view.
            
            PieceLabel.text = (PieceNameList[ChosenPiece] + " by " + PieceList[ChosenPiece])
            
            configureCaptureSession()
            session.startRunning()
            
            TiltTurnViews()
            
            let defaults = UserDefaults.standard
            let PageCountValue = ["PageCount" : 1]
            defaults.register(defaults: PageCountValue)
              
            let startnum = 1
            defaults.set(startnum, forKey: "PageCount")
            let PageNum = defaults.integer(forKey: "PageCount")
            print(self.NameofPiece)
            print(ChosenPiece)
            getImage(imageName: "\(self.NameofPiece)page\(PageNum)")
            
        }

     
        

        
        
        
        
        
        
        
        
      
        
        
        var sequenceHandler = VNSequenceRequestHandler()
          

        @IBOutlet weak var changingLabel: UILabel!
        
        @IBOutlet weak var detectedornot: UILabel!
        
        let session = AVCaptureSession()
        var previewLayer: AVCaptureVideoPreviewLayer!
          
          let dataOutputQueue = DispatchQueue(
            label: "video data queue",
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .workItem)

    //      override func viewDidLoad() {
    //        super.viewDidLoad()
    //        configureCaptureSession()
    //
    //        session.startRunning()
    //      }
          
          //--------------------------------------------------------------------
          
          
          func detectedFace(request: VNRequest, error: Error?) {
            // 1
            guard
              let results = request.results as? [VNFaceObservation],
              let result = results.first
              else {
                // 2
                //faceView.clear()
//                DispatchQueue.main.async {
//                  self.detectedornot.text = "face not detected"
//                }
                return
            }
//            DispatchQueue.main.async {
//              self.detectedornot.text = "face detected"
//            }
            faceturn(for: result)

          }
          
          
    
    
    
    
    
    
    
    //MARK: VNFaceObservation
    
    func faceturn(for result: VNFaceObservation) {
           
            
        let roll = result.roll ?? 0.0
        print(roll.doubleValue)
        
        let yaw = result.yaw ?? 0.0
        print(yaw.doubleValue)
        


        
        
        
//------------------- ROLL -----------------------------------------------------
        
        if tiltTrueturnFalse == true {
        
            if roll == 0.0 {
                lookedRightorLeft = false
            }
            
    //------------- tilted right -----------------
            if !lookedRightorLeft && roll.doubleValue < -0.5 {
                    
               
                    
                        let defaults = UserDefaults.standard
                        var PageNum = defaults.integer(forKey: "PageCount")
                        PageNum += 1
                        
                        getImage(imageName: "\(NameofPiece)page\(PageNum)")
                        
                        if areTherePages == true {
                            defaults.set(PageNum, forKey: "PageCount")
                        }
                    
                        areTherePages = true;
                
            }
                    
    //-------------- tilted left ------------------
                else if !lookedRightorLeft && roll.doubleValue > 0.5 {
                    
                   
                    
                        let defaults = UserDefaults.standard
                        var PageNum = defaults.integer(forKey: "PageCount")
                        PageNum -= 1
                        
                        getImage(imageName: "\(NameofPiece)page\(PageNum)")
                        
                        if areTherePages == true {
                            defaults.set(PageNum, forKey: "PageCount")
                        }
                        
                        areTherePages = true;
                    
                    
                }

        }
        
        

//------------------- YAW -----------------------------------------------------

        if tiltTrueturnFalse == false {
            if yaw == 0.0 {
                lookedRightorLeft = false
            }

    //------------- looked right -----------------
            
            if !lookedRightorLeft && yaw.doubleValue > 0.7 {
                
                let defaults = UserDefaults.standard
                var PageNum = defaults.integer(forKey: "PageCount")
                PageNum += 1
                
                getImage(imageName: "\(NameofPiece)page\(PageNum)")
                
                if areTherePages == true {
                    defaults.set(PageNum, forKey: "PageCount")
                }
                
                areTherePages = true;
            }
                
    //-------------- looked left ------------------
                
            else if !lookedRightorLeft && yaw.doubleValue < -0.7 {
                
                let defaults = UserDefaults.standard
                var PageNum = defaults.integer(forKey: "PageCount")
                PageNum -= 1
                
                getImage(imageName: "\(NameofPiece)page\(PageNum)")
                
                if areTherePages == true {
                    defaults.set(PageNum, forKey: "PageCount")
                }
                
                areTherePages = true;
                
            }
        }
    }
}







        // MARK: - Video Processing methods

        extension DisplayViewController {
          func configureCaptureSession() {
            // Define the capture device we want to use
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .front) else {
              fatalError("No front video camera available")
            }

            // Connect the camera to the capture session input
            do {
              let cameraInput = try AVCaptureDeviceInput(device: camera)
              session.addInput(cameraInput)
            } catch {
              fatalError(error.localizedDescription)
            }

            // Create the video data output
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

            // Add the video output to the capture session
           session.addOutput(videoOutput)

    //        let videoConnection = videoOutput.connection(with: .video)
    //        videoConnection?.videoOrientation = .portrait

    //        // Configure the preview layer
    //        previewLayer = AVCaptureVideoPreviewLayer(session: session)
    //        previewLayer.videoGravity = .resizeAspectFill
    //        previewLayer.frame = view.bounds
    //        view.layer.insertSublayer(previewLayer, at: 0)
          }
        }

        // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate methods

        extension DisplayViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
          func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
              return
            }

            // 2
            let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)

            // 3
            do {
              try sequenceHandler.perform(
                [detectFaceRequest],
                on: imageBuffer,
                orientation: .leftMirrored)
            } catch {
              print(error.localizedDescription)
            }

          }
            
 
 
       }
    
    
    

