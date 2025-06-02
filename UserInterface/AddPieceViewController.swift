//
//  AddPieceViewController.swift
//  UserInterface
//
//  Created by Daniel Rosario on 2/23/20.
//  Copyright © 2020 Daniel Rosario. All rights reserved.
//

import UIKit

class AddPieceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate  {

   
    
    var addedPiece = true
    
    var PiecePagesList = UserDefaults.standard.stringArray(forKey: "PagesList")
    
    
    
    
    @IBOutlet weak var AddTitleTextfield: UITextField!
    @IBOutlet weak var AddComposerTextfield: UITextField!
    @IBOutlet weak var DoneNamingButton: UIButton!
    @IBOutlet weak var ImportPieceButton: UIButton!
    @IBOutlet weak var NoteToImport: UILabel!
    @IBOutlet weak var AddPieceButtonView: UIView!
    
    

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        NoteToImport.isHidden = true
        ImportPieceButton.isHidden = true
        DoneNamingButton.isHidden = false
        AddTitleTextfield.isHidden = false
        AddComposerTextfield.isHidden = false
        AddPieceButtonView.backgroundColor = UIColor.clear
        
        AddTitleTextfield.text = "Add Title of Piece"
        AddComposerTextfield.text = "Add Composer"
        AddTitleTextfield.delegate = self
        AddComposerTextfield.delegate = self
        
        let defaults = UserDefaults.standard
            let PageNumDefault = ["PageNum" : 0]
            defaults.register(defaults: PageNumDefault)
            let PagesListDefault = ["PagesList" : [String]()]
            defaults.register(defaults: PagesListDefault)
            
            AddPieceCollectionView.dataSource = self
            AddPieceCollectionView.delegate = self
            
            collectionViewLayout()
            
        }
    
    
    @IBAction func DoneNamingPressed(_ sender: Any) {
        AddTitleTextfield.isHidden = true
        AddComposerTextfield.isHidden = true
        DoneNamingButton.isHidden = true
        ImportPieceButton.isHidden = false
        NoteToImport.isHidden = false
    }
    

    @IBAction func CancelAddPiece(_ sender: Any) {
        
      
          
        let defaults = UserDefaults.standard
       // var piecenum = defaults.integer(forKey: "PieceNum")
        var pagenum1 = defaults.integer(forKey: "PageNum")
        
        print(PiecePagesList!.count)
        
     
        if PiecePagesList?.isEmpty == false {

            for i in 1...2 {
                print(i)
            }
            
            for index in 1..<(PiecePagesList!.count) {
                print(PiecePagesList?[index])
                removeImage(imageName: "\(PiecePagesList?[index])")
            }
        }
        
        let resetPageNum1 = 0
        let resetPagesList1: [String] = []
        defaults.set(resetPageNum1, forKey: "PageNum")
        defaults.set(resetPagesList1, forKey: "PagesList")
        
    }
    
    
    
    
    @IBAction func AddPiece(_ sender: Any) {
        
        performSegue(withIdentifier: "toView", sender: self)
        
        let resetPageNum = 0
        let resetPagesList: [String] = []
        let defaults = UserDefaults.standard
        defaults.set(resetPageNum, forKey: "PageNum")
        defaults.set(resetPagesList, forKey: "PagesList")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "toView" {
            if AddTitleTextfield?.text != "" && AddComposerTextfield.text != "" {
            
                let defaults = UserDefaults.standard
                let NumofPages = defaults.integer(forKey: "PageNum")
            print("NumofPages is \(NumofPages)")
                let viewController = segue.destination as! ViewController
                
                viewController.newPiece = AddTitleTextfield.text!
                viewController.newDescription = AddComposerTextfield.text!
                viewController.addedPiece = addedPiece
                viewController.PageCount = NumofPages
            }
            
            else {return}
        }
        else {return}
    }
    
    
    


    //MARK: Image Functions
    
    
    var newpieceimage: UIImage?
    
    @IBAction func ImportPiece(_ sender: Any) {
        
        let pieceimage = UIImagePickerController()
        pieceimage.delegate = self
        
        pieceimage.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        pieceimage.allowsEditing = false
        
        self.present(pieceimage, animated: true)
        
    }
    
          
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        newpieceimage = info[.originalImage] as? UIImage
              
        self.dismiss(animated: true, completion: nil)
          
        let defaults = UserDefaults.standard
       // var piecenum = defaults.integer(forKey: "PieceNum")
        var pagenum = defaults.integer(forKey: "PageNum")
          
        pagenum += 1
        
        let NameofPiece: String = AddTitleTextfield.text!.replacingOccurrences(of: " ", with: "")
        let importedimage = "\(NameofPiece)page\(pagenum)"
    
        saveImage(imageName: importedimage)
        
        PiecePagesList?.append(importedimage)
        print(PiecePagesList)
        defaults.set(PiecePagesList, forKey: "PagesList")
        defaults.set(pagenum, forKey: "PageNum")
        print("PiecePagesList \(PiecePagesList?.count)")
    
    AddPieceButtonView.backgroundColor = UIColor.systemTeal
    AddPieceCollectionView.reloadData()
      
  }
  
  func saveImage(imageName: String){
     //create an instance of the FileManager
     let fileManager = FileManager.default
     //get the image path
     let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
     //get the image we took with camera
      let newjoke = newpieceimage!
     //get the PNG data for this image
      let data = newjoke.jpegData(compressionQuality: 0.0)
     //store it in the document directory
      fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
  }
  
    
    func getImportedImage(imageName: String) -> UIImage {
        var cellImage = UIImage()
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath) {
            cellImage = UIImage(contentsOfFile: imagePath)!
        }
        else {
            print("Panic! No Image!")
        }
        return cellImage
    }
    

    func removeImage(imageName: String){

        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent("\(imageName)")
    
        if fileManager.fileExists(atPath: "\(destinationPath)") {
            
            try! fileManager.removeItem(atPath: destinationPath)
            print("\(imageName) removed")
        }
        
        else {return}
    }
    
    
    
    
    
   //MARK: - AddPieceCollectionView
    
    @IBOutlet weak var AddPieceCollectionView: UICollectionView!
    
    
    
    let items = ["piece 1", "piece 2", "piece 3"]
    
    

    
    func collectionViewLayout() {
        
        let cellSizeWidth = UIScreen.main.bounds.width / 3 - 20
        let cellSizeHeight = cellSizeWidth * 1.375
        let spacing = UIScreen.main.bounds.width / 4
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: cellSizeWidth, height: cellSizeHeight)
        
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        AddPieceCollectionView.collectionViewLayout = layout
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        
        if PiecePagesList?.count != nil {
            return PiecePagesList!.count
        }
        else {return 0}
    }

       
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPieceCollectionCell", for: indexPath) as! AddPieceCollectionViewCell

               
        if PiecePagesList?[indexPath.item] != nil {
            cell.AddPieceCellImage.image = getImportedImage(imageName: PiecePagesList![indexPath.item])
       }

        return cell
    }
    
    
    
    
    
    
    
    
}
