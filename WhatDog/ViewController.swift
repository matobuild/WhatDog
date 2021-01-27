//
//  ViewController.swift
//  WhatDog
//
//  Created by kittawat phuangsombat on 2021/1/27.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("could not convert image to CIImage")
            }
            detect(dogImage: convertedCIImage)
            
            imageView.image = userPickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(dogImage: CIImage) {
        
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: DogClassification_1(configuration: config).model) else{
            fatalError("ERROR LOADING COREML MODEL FAILED")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not complete classfication")
            }
            self.navigationItem.title = result.identifier.capitalized
            
        }
        let handler =  VNImageRequestHandler(ciImage: dogImage)
        
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
        
    }
    
    @IBAction func CameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

