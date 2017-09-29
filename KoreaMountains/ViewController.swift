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

/**
 * TODO LIST
 - searchbar 추가 : done
 - refreshcontroller 추가 (runtime error 해결필요)
 - indicator 추가
 - didselect -> 화면 푸시, 산 정보 상세 조회 (지도API로 지도를 표시해볼까?)
 */
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {//}, UISearchResultsUpdating {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var mList = [mountainInfo]()
    var refreshControl : UIRefreshControl!
    var isSearching = false
    var isDataLoaded = false
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.isNavigationBarHidden = true
        
        searchBar.placeholder = "알고 싶은 산 이름을 입력하세요."
        tableview.tableHeaderView = searchBar
        // set up searchController
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = true
//        tableview.tableHeaderView = searchController.searchBar
        
        // set up refreshController
//        refreshControl = UIRefreshControl()
//        tableview.refreshControl = refreshControl
//        
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationController!.isNavigationBarHidden == false {
            self.navigationController!.isNavigationBarHidden = true
        }
        
        if isDataLoaded == false {
            getMountainInfo(nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell

        if let indexPath = tableview.indexPath(for: cell) {
            let selectedMountain = mList[indexPath.row]
            
            print("selected name : \(selectedMountain.mName!)")
            
            if let viewController = segue.destination as? KMInfoDetailViewController {
                viewController.mInfo = selectedMountain
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text!
        mList.removeAll()
        isSearching = true
        getMountainInfo(keyword)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let keyword = searchBar.text!
        mList.removeAll()
        isSearching = true
        getMountainInfo(keyword)
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
    
    func refreshData() {
        //--------------- runtime error ----------------
        // data 초기화
        mList.removeAll()
        isSearching = true
        
        getMountainInfo(nil)
        refreshControl.endRefreshing()
    }
    
    func getMountainInfo(_ searchKeyword : String?) {
        var parameters = [String : String]()
        if let searchKeyword = searchKeyword
        {
            parameters["searchWrd"] = searchKeyword
        }
        parameters["pageNo"] = String(1)
        parameters["numOfRows"] = String(20)
        
        let userRequest = KMApiRequest()
        
        userRequest.requestGetUrl(uri:"/mntInfoOpenAPI", params: parameters, completion: { json in
            self.isDataLoaded = true
            
            if  let json = json,
                let items = json["item"] as? [[String:Any]] {
                for item in items {
                    var mountain = mountainInfo()
                    mountain = self.makeMInfoObject(obj: item)
                    self.mList.append(mountain)
                }
                self.isSearching = false
                self.tableview.reloadData()
            } else if let json = json,
                let item = json["item"] as? [String:Any] {
                var mountain = mountainInfo()
                mountain = self.makeMInfoObject(obj: item)
                self.mList.append(mountain)
                
                self.isSearching = false
                self.tableview.reloadData()
            }
        })
    }
    
    func makeMInfoObject(obj:[String:Any]) -> mountainInfo {
        var mountain = mountainInfo()
        
        if let name = obj["mntiname"] as? String {
            mountain.mName = name
        }
        
        if let id = obj["mntilistno"] as? Int {
            mountain.mId = id
        }
        
        if let addr = obj["mntiadd"] as? String {
            mountain.mAddr = addr
        }
        
        if let detail = obj["mntidetails"] as? String {
            mountain.mDetail = detail
        }
        
        return mountain
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

