//
//  FavoritesVC.swift
//  hw5_xcodeproj
//
//  Created by S on 2/8/20.
//  Copyright © 2020 SH. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    weak var delegate: PlacesFavoritesDelegate?
    
    let favPlacesAnnoDct = UserDefaults.standard.object(forKey: "favPlacesAnnoDct")
        as? Dictionary<String, Dictionary<String, Any>> ?? Dictionary<String, Dictionary<String, Any>>()
    lazy var favPlacesAnnoDctArr = Array(favPlacesAnnoDct)
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favPlacesAnnoDct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell_id")
        cell.textLabel?.text = favPlacesAnnoDctArr[indexPath.row].key
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if debug {"Selected row: \(favPlacesAnnoDctArr[indexPath.row].key)"}
        let lat = favPlacesAnnoDctArr[indexPath.row].value["lat"]
        let long = favPlacesAnnoDctArr[indexPath.row].value["long"]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func touchXMark(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
