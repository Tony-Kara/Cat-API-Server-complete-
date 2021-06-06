//
//  CatListVC.swift
//  ROUGH API2
//
//  Created by mac on 6/6/21.
//

import UIKit

class CatListVC: UITableViewController {

    var catNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCatsBreed()

    }
    
    func getCatsBreed() {
        NetworkService.instance.getCatBreeds { catNames in
            self.catNames = catNames
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catNames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "tony", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = catNames[indexPath.row]
        return cell
       
    }
   

}
