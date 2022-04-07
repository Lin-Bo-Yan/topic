//
//  liveStreamingCVC.swift
//  topic
//
//  Created by Class on 2022/4/7.
//

import UIKit

private let reuseIdentifier = "Cell"

class liveStreamingCVC: UICollectionViewController {
    var stamers = [stream_list]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        liveStreamingCVC.registerClass(
//            liveStreamingCell.self,
//          forCellWithReuseIdentifier: "Cell")
        
        
        collectionView.dataSource = self
        let list : mySteamer = load("result")
        stamers = list.result.stream_list
        //print(stamers)
    }

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return stamers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! liveStreamingCell
        cell.headPhoto.image = UIImage(named: "brokenHeart")
        cell.headPhoto.contentMode = .scaleToFill
        cell.headPhoto.clipsToBounds = true
        cell.nickName.text = stamers[indexPath.row].nickname.capitalized
        cell.onlineNum.text = String(stamers[indexPath.row].online_num)
        cell.streamTitle.text = stamers[indexPath.row].stream_title
        cell.tags.text = stamers[indexPath.row].tags
        
        
        
        getData(stamers[indexPath.row].head_photo,  cell.headPhoto)
        return cell
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
