//
//  ViewController.swift
//  UserInterface
//
//  Created by Daniel Rosario on 2/23/20.
//  Copyright © 2020 Daniel Rosario. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    
    var TablePieceList = UserDefaults.standard.stringArray(forKey: "TitleList")
    var DescList = UserDefaults.standard.stringArray(forKey: "DescList")
    var PageCountList = (UserDefaults.standard.array(forKey: "CountList") ?? []) as? [Int]
       
    var ChosenPiece = Int()
    var newPiece = String()
    var newDescription = String()
    var addedPiece = false
    var PageCount = Int()

    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           PieceTableView.dataSource = self
           PieceTableView.delegate = self
        
        let defaults = UserDefaults.standard
        let DefaultTitleList = ["TitleList": []]
            defaults.register(defaults: DefaultTitleList)
        let DefaultDescList = ["DescList": []]
            defaults.register(defaults: DefaultDescList)
        let DefaultPieceCountList = ["CountList": []]
            defaults.register(defaults: DefaultPieceCountList)
        
        if addedPiece == true {
            addPiece()
            PieceTableView.reloadData()
            addedPiece = false
        }
        else {
            PieceTableView.reloadData()
            addedPiece = false
        }
        
       }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if addedPiece == true {
//            addPiece()
//            PieceTableView.reloadData()
//            addedPiece = false
//        }
//        else {
//            PieceTableView.reloadData()
//        }
//    }
    
    
    
   
    
    
    
  //MARK: - Table View Functions
    
    
    @IBOutlet weak var PieceTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
                
        print("title list", TablePieceList?.count as Any)
        print("desc list", DescList?.count as Any)
        print("pagecount list", PageCountList?.count as Any)
        
        return TablePieceList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PieceCell", for: indexPath) as! PieceTableViewCell
        let imageInCell: String = TablePieceList![indexPath.row].replacingOccurrences(of: " ", with: "")
        
        if PageCountList?[indexPath.row] != 0 {
            cell.pieceCellImage.image = getPieceCellImage(imageName: "\(imageInCell)page1")
        }
        
        cell.pieceCellTitle.text = TablePieceList?[indexPath.row]
        cell.pieceCellView.layer.cornerRadius = cell.pieceCellView.frame.height / 4
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
         if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let removedPiece: String = TablePieceList![indexPath.row].replacingOccurrences(of: " ", with: "")
            
            print(PageCountList!)
            print(indexPath.row)
            

            if PageCountList?[indexPath.row] != 0 {

                for i in 1...PageCountList![indexPath.row] {
                    removeImage(imageName: "\(removedPiece)page\(i)")
                }
            }
            
            
            
            TablePieceList?.remove(at: indexPath.row)
            DescList?.remove(at: indexPath.row)
            PageCountList!.remove(at: indexPath.row)
        
            let defaults = UserDefaults.standard
            defaults.set(TablePieceList, forKey: "TitleList")
            defaults.set(DescList, forKey: "DescList")
            defaults.set(PageCountList, forKey: "CountList")
            
            PieceTableView.reloadData()
            
        }
    }
    
    
    
    func addPiece(){
        
        print("add piece running ", PageCount)
        
        TablePieceList?.append(newPiece)
        DescList?.append(newDescription)
        PageCountList?.append(PageCount)
        
        print(PageCount)
        print(TablePieceList!)
        print(DescList!)
        print(PageCountList!)
        
        let defaults = UserDefaults.standard
        defaults.set(TablePieceList, forKey: "TitleList")
        defaults.set(DescList, forKey: "DescList")
        defaults.set(PageCountList, forKey: "CountList")
        
        newPiece = ""
        newDescription = ""
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        ChosenPiece = indexPath.row
        
        performSegue(withIdentifier: "toDisplay", sender: self)
    }
    
    
    
    
    
//MARK: Image functions

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
    
    
    func getPieceCellImage(imageName: String) -> UIImage {
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
    
    
    
    
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        
        if segue.identifier == "toDisplay" {
            
            let SentNameofPiece = TablePieceList![ChosenPiece].replacingOccurrences(of: " ", with: "")
            
            let displayController = segue.destination as! DisplayViewController
            
            displayController.PieceNameList = TablePieceList ?? [""] 
            displayController.PieceList = DescList ?? [""]
            displayController.ChosenPiece = ChosenPiece
            displayController.NameofPiece = SentNameofPiece
            
          
        }
            
        else {return}
    }
    
    
}

