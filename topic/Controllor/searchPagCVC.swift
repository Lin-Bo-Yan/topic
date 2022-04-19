//
//  searchPagCVC.swift
//  topic
//
//  Created by Class on 2022/4/12.
//

import UIKit

private let reuseIdentifier = "CellSearch"

class searchPagCVC: UICollectionViewController ,UISearchBarDelegate, UISearchResultsUpdating{
    
    let searchController = UISearchController(searchResultsController: nil)
    //還沒經過搜尋過的資料
    var stamers = [lightyear_list]()
    //已經搜尋過的資料
    var searchedBooks: [lightyear_list]!
    @IBOutlet var myCView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let fullScreenSize = collectionView.bounds.width/2 - 20
        let fullScreenSizeTwo = collectionView.bounds.width/2 - 20
        layout.itemSize = CGSize(width:fullScreenSize, height: fullScreenSizeTwo)
        layout.minimumLineSpacing = 5 //設定cell與cell間的縱距
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        let list : mySteamer = load("result")
        stamers = list.result.lightyear_list
        searchedBooks = stamers
        configuresearchController()
    }
    // 配置搜索控制器
    private func configuresearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.placeholder = "Search"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //  點擊CollectionViewCell跳轉到直播影片
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "liveRoomID") as? liveRoomVC
        { controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    //搜尋條件  為什麼沒辦法用 searchedBooks.append(i)
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if searchText.isEmpty {
            searchedBooks = stamers
        } else  {
            
            for i in stamers {
                if i.nickname.uppercased().contains(searchText.uppercased())
                {
                    searchedBooks = stamers.filter({ name in
                        name.nickname.uppercased().contains(searchText.uppercased())
                    })
                }
                else if i.stream_title.uppercased().contains(searchText.uppercased())
                {
                    searchedBooks = stamers.filter({ title in
                        title.stream_title.uppercased().contains(searchText.uppercased())
                    })

                }
                else if i.tags.uppercased().contains(searchText.uppercased())
                {
                    searchedBooks = stamers.filter({ tags in
                        tags.tags.uppercased().contains(searchText.uppercased())
                    })
                }
            }
        }
        myCView.reloadData()
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
            self.searchController.searchResultsUpdater
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return searchedBooks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! searchPagCell
        
        cell.headPhotoSearch.image = UIImage(named: "paopao")
        cell.headPhotoSearch.contentMode = .scaleToFill
        cell.headPhotoSearch.clipsToBounds = true
        cell.nickNameSearch.text = searchedBooks[indexPath.row].nickname.capitalized
        cell.onlineNumSearch.text = "\(searchedBooks[indexPath.row].online_num)"
        cell.streamTitleSearch.text = searchedBooks[indexPath.row].stream_title
        cell.tagsSearch.text = searchedBooks[indexPath.row].tags
        getData(searchedBooks[indexPath.row].head_photo,  cell.headPhotoSearch)

        return cell
    }

    

}
