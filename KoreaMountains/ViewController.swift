//
//  ViewController.swift
//  KoreaMountains
//
//  Created by Emily on 2017. 9. 10..
//  Copyright © 2017년 Emily. All rights reserved.
//

import UIKit

struct mountainInfo {
    var mId:Int?        //산정보코드
    var mName:String?   //산명
    var mAddr:String?   //소재지
    var mTop:String?    //명산
    var mSummary:String?    //산정보개관
    var mDetail:String? //산정보 상세
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    var mList = [mountainInfo]()
    var refreshControler : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableview.refreshControl = refreshControler
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMountainInfo()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let mountainInfo = mList[indexPath.row]
        cell.textLabel?.text = mountainInfo.mName//"\(String(describing: mountainInfo.mName!)) (\(String(describing: mountainInfo.mId!)))"
        cell.detailTextLabel?.text = mountainInfo.mAddr
        
        return cell
    }
    
    func getMountainInfo() {
        var parameters = [String : String]()
//        parameters["searchWrd"] = "북한산"
        parameters["pageNo"] = String(1)
        parameters["numOfRows"] = String(20)
        
        let userRequest = KMApiRequest()
        
        userRequest.requestGetUrl(uri:"/mntInfoOpenAPI", params: parameters, completion: { json in
            
            if let items = json["item"] as? [[String:Any]] {
                for item in items {
                    var mountain = mountainInfo()
                    
                    if let name = item["mntiname"] as? String {
                        mountain.mName = name
                        print("name : \(name)")
                    }
                    
                    if let id = item["mntilistno"] as? Int {
                        mountain.mId = id
                        print("id : \(id)")
                    }
                    
                    if let addr = item["mntiadd"] as? String {
                        mountain.mAddr = addr
                        print("addr : \(addr)")
                    }
                    
                    if let detail = item["mntidetails"] as? String {
                        mountain.mDetail = detail
                    }
                    
                    self.mList.append(mountain)
                }
                self.tableview.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

