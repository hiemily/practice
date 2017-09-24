//
//  MountainDetailViewController.swift
//  KoreaMountains
//
//  Created by Emily on 2017. 9. 24..
//  Copyright © 2017년 Emily. All rights reserved.
//

import UIKit

class KMInfoDetailViewController: UIViewController {

    @IBOutlet weak var testlabel: UILabel!
    var mInfo : mountainInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        testlabel.text = mInfo!.mName
        
        getMountainImage()
    }
    
    func getMountainImage() {
        var parameters = [String : String]()
        if let mInfo = mInfo {
            parameters["mntiListNo"] = String(describing: mInfo.mId!)
        }
        
        let userRequest = KMApiRequest()
        
        userRequest.requestGetUrl(uri:"/mntInfoImgOpenAPI", params: parameters, completion: { json in
            
            if let items = json["item"] as? [[String:Any]] {
                print(items)
            } else if let item = json["item"] as? [String:Any] {
                print(item)
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
