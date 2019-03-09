//
//  ViewController.swift
//  Handwritten Digit Recognizer
//
//  Created by Prateek Gupta on 08/03/19.
//  Copyright © 2019 Prateek Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var digitLabel: UILabel!
    @IBOutlet weak var canvasView: CanvasView!
    
    var pixelBuffer: CVPixelBuffer?
    let context = CIContext()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault,
                            28,
                            28,
                            kCVPixelFormatType_OneComponent8,
                            attrs,
                            &pixelBuffer)
    }
    
    @IBAction func clearCanvas(_ sender: Any) {
        canvasView.lines = []
        canvasView.setNeedsDisplay()
        digitLabel.isHidden = true
        
    }
    
    @IBAction func recognizeDigit(_ sender: Any) {
        // Fancy Image conversions
        let viewContext = canvasView.getViewContext()
        let cgImage = viewContext?.makeImage()
        let ciImage = CIImage(cgImage: cgImage!)
        context.render(ciImage, to: pixelBuffer!)
        // Predict
        let output = try? MNIST_CNN().prediction(image: pixelBuffer!)
        // Output
        digitLabel.text = output?.classLabel
        digitLabel.isHidden = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

