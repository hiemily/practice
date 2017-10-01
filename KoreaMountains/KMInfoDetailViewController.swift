//
//  MountainDetailViewController.swift
//  KoreaMountains
//
//  Created by Emily on 2017. 9. 24..
//  Copyright © 2017년 Emily. All rights reserved.
//

import UIKit
import Nuke

struct mountainImg {
    var mImgNo:Int?             //파일번호
    var mImgFileName:String?    //파일명
    var imgName:String?         //이미지타이틀
}

class KMInfoDetailViewController: UIViewController {

//    @IBOutlet weak var backgroundScrollview: UIScrollView!
    @IBOutlet weak var mDescriptionLabel: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var imageTitleLabel: UILabel!

    var mInfo : mountainInfo?
    var mImageArr = [mountainImg]()
    let imgUrl = "http://www.forest.go.kr/images/data/down/mountain/"
    
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
        
        getMountainImage()
    }
    
    func getMountainImage() {
        mDescriptionLabel.text = mInfo!.mDetail

        var parameters = [String : String]()
        if let mInfo = mInfo {
            parameters["mntiListNo"] = String(describing: mInfo.mId!)
        }
        
        let userRequest = KMApiRequest()
        
        userRequest.requestGetUrl(uri:"/mntInfoImgOpenAPI", params: parameters, completion: { json in
            if  let json = json,
                let items = json["item"] as? [[String:Any]] {
                var i:CGFloat = 0;
                for item in items {
                    var mImage = mountainImg()
                    mImage = self.makeMImgObject(obj: item)
                    self.mImageArr.append(mImage)

                    if let title = mImage.imgName {
                        self.imageTitleLabel.text = title
                    }

                    if let imageUrl = mImage.mImgFileName,
                        let url = URL(string: imageUrl) {
                        print(url)

                        let imageview = UIImageView(frame:CGRect(x:i * self.imagesScrollView!.frame.size.width, y:0, width:self.imagesScrollView!.frame.size.width, height:self.imagesScrollView!.frame.size.height))
                        Nuke.loadImage(with:url, into:imageview)
                        self.imagesScrollView!.addSubview(imageview)

                        i += 1;
                    }
                }
                self.imagesScrollView!.contentSize = CGSize(width:self.imagesScrollView.frame.size.width * CGFloat(items.count), height:self.imagesScrollView.frame.height)
            } else if let json = json,
                let item = json["item"] as? [String:Any] {
                var mImage = mountainImg()
                
                mImage = self.makeMImgObject(obj: item)
                self.mImageArr.append(mImage)
                
                if let title = mImage.imgName {
                    self.imageTitleLabel.text = title
                }

                if let imageUrl = mImage.mImgFileName,
                    let url = URL(string: imageUrl) {
                    print(url)

                    let imageview = UIImageView(frame:CGRect(x:0, y:0, width:self.imagesScrollView!.frame.size.width, height:self.imagesScrollView!.frame.size.height))
                    Nuke.loadImage(with:url, into:imageview)
                    self.imagesScrollView!.addSubview(imageview)
                }
            } else {
                self.imagesScrollView!.removeFromSuperview()
                self.imageTitleLabel!.removeFromSuperview()
            }
        })
    }
    
    func makeMImgObject(obj:[String:Any]) -> mountainImg {
        var imageObj = mountainImg()
        
        if let mImgNo = obj["imgno"] as? Int {
            imageObj.mImgNo = mImgNo
        }
        
        if let name = obj["imgname"] as? String {
            imageObj.imgName = name
        }
        
        if let fileName = obj["imgfilename"] as? String {
            imageObj.mImgFileName = imgUrl + fileName
        }
        
        return imageObj
    }
}
