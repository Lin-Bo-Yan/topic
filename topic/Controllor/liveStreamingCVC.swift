//
//  liveStreamingCVC.swift
//  topic
//
//  Created by Class on 2022/4/7.
//

import UIKit
import AVFoundation
import AVKit

private let reuseIdentifier = "Cell"

class liveStreamingCVC: UICollectionViewController {
    var stamers = [stream_list]()
    var fullScreenSize :CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let fullScreenSize = collectionView.bounds.width/2 - 10
        let fullScreenSizeTwo = collectionView.bounds.width/2 - 10
        layout.itemSize = CGSize(width:fullScreenSize, height: fullScreenSizeTwo)
        layout.minimumLineSpacing = 5 //設定cell與cell間的縱距
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        let list : mySteamer = load("result")
        stamers = list.result.stream_list
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return stamers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 連結cell 要下

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! liveStreamingCell
        
        cell.headPhoto.image = UIImage(named: "paopao")
        cell.headPhoto.contentMode = .scaleToFill
        cell.headPhoto.clipsToBounds = true
        cell.nickName.text = stamers[indexPath.row].nickname.capitalized
        cell.onlineNum.text = String(stamers[indexPath.row].online_num)
        cell.streamTitle.text = stamers[indexPath.row].stream_title
        cell.tags.text = stamers[indexPath.row].tags
        getData(stamers[indexPath.row].head_photo,  cell.headPhoto)
        return cell
    }
    //  點擊CollectionViewCell跳轉到直播影片
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "liveRoomID") as? liveRoomVC
        { controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: "json")
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        do {
            let decoder = JSONDecoder()
            
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func getData (_ url_str:String, _ imageView:UIImageView){
        let url:URL = URL(string:url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data ,responds,error) in
            if data != nil{
                let image = UIImage(data: data!)
                if(image != nil){
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                    })
                }
               
            }
        })
        task.resume()
    }
    
    
     
    }


//        liveStreamingCVC.registerClass(
//            liveStreamingCell.self,
//          forCellWithReuseIdentifier: "Cell")
