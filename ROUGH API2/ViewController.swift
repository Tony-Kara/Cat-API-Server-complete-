//
//  ViewController.swift
//  ROUGH API2
//
//  Created by mac on 5/16/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var catFactLbl: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var barOnelbl: UILabel!
    @IBOutlet weak var barTwoLbl: UILabel!
    @IBOutlet weak var barThreeLbl: UILabel!
    
    
    @IBOutlet weak var barOneWidth: NSLayoutConstraint!
    @IBOutlet weak var barTwoWidth: NSLayoutConstraint!
    @IBOutlet weak var barThreeWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        
    
    }

    @IBAction func getCatFact(_ sender: UIButton) {
       
        NetworkService.instance.makeFactRequest { [weak self] fact in
            guard let self = self else { return }
            self.catFactLbl.text = fact
        }
        
        NetworkService.instance.downloadCatImage { [weak self]  image, url in
            guard let self = self else { return }
            self.catImageView.image = image
            
            NetworkService.instance.getCatImageTags(imgUrl: url) { cats in
                self.plotBarGraphData(cats: cats)
            }
        }
        
    }
    
    
    @IBAction func learnMoreClicked(_ sender: UIButton) {
    
    
    
    }
    
   
    func plotBarGraphData(cats: [ClarifaiCat]) {
      
        let imageWidth = catImageView.frame.width
        
        guard let catOne = cats.randomElement(),
              let   catTwo = cats.randomElement(),
              let   catThree = cats.last else{return}
              
        
        barOneWidth.constant = catOne.probability * imageWidth
        barTwoWidth.constant = catTwo.probability * imageWidth
        barThreeWidth.constant = catThree.probability * imageWidth
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            // runs after the animatio0n completes
            self.barOnelbl.text = "\(catOne.name.capitalized): \(catOne.percentage)"
            self.barTwoLbl.text = "\(catTwo.name.capitalized): \(catTwo.percentage)"
            self.barThreeLbl.text = "\(catThree.name.capitalized): \(catThree.percentage)"
            
        }

        
    }
    
    
   
    
}

