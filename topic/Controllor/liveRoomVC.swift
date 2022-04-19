//
//  liveRoomVC.swift
//  topic
//
//  Created by Class on 2022/4/13.
//

import UIKit
import AVFoundation
import FirebaseAuth
import AVKit

private let reuseIdentifier = "chatTVCell"
class liveRoomVC: UIViewController {
    
    let liveRoomVC = UIViewController()
    var player : AVPlayer?
    var chatArry = [String]()
    var userNameToChat = [String]()
    var nameID = "訪客"
    var webSocket : URLSessionWebSocketTask?

    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet var chatTV: UITableView!
    @IBOutlet var chatBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTV.separatorStyle = .none // table的線隱藏
        chatTV.showsVerticalScrollIndicator = false // table的捲動條
        chatBox.delegate = self
        view.layer .addSublayer(self.layer) // 呼叫播放器
        player?.play()  //進行播放
        self.view.layer.insertSublayer(layer, at: 0)//放在圖層底部
    }
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            guard user != nil else{
                print("沒有監聽到資料")
                self.openWebSocket()
                return
            }
            guard
                let email = user?.email,
                let nickName = user?.displayName
            else {
                print("有資料，但拿的時候出問題了")
                return
            }
            self.nameID = nickName
            //print("暱稱\(nameID)")
                self.openWebSocket()
                
        })
    } // viewWillAppear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        guard handle != nil else {
            return
        }
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    override func viewDidLayoutSubviews(){
        layer.frame = view.bounds //佔滿視窗
    }
    
    
    
    
    // 建立連線
    func openWebSocket() {
        
                let urlString = "wss://lott-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(nameID)"
                //let str = urlString
                let strAfter = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let url = URL(string: strAfter!) {
                var request = URLRequest(url: url)
                let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
                webSocket = session.webSocketTask(with: request)
                webSocket?.resume()
                print("連線成功")
            }
    }
    // 一般發話
    func sessionWebSocketTaskMessage(_ wSsendText:String){ 
        let message = URLSessionWebSocketTask.Message.string("{\"action\":\"N\",\"content\":\"\(wSsendText)\"}")
        webSocket?.send(message) { error in
            if let error = error {
            print(error)
            }
        }
    }
    // 接收
    func sessionWebSocketTaskReceive(){
        webSocket?.receive { result in
            switch result {
                case .failure(let error):
                    print("沒有接受到資料\(error)")
                case .success(let message):
                    switch message {  //這裡只有一個 case 和一個 default，有字串就繼續做，沒有字串default就print錯誤
                    case .string(let text):
                        let data = text.data(using: .utf8)
                        do{
                            let test = try? JSONDecoder().decode(WSResponseModel.self, from: data!)
                            switch test?.sender_role{
                            case -1:
                                self.chatArry.append(test!.body!.text!)
                                self.userNameToChat.append(test!.body!.nickname!)
                            case 5:
                                self.chatArry.append(test!.body!.content!.tw!)
                                self.userNameToChat.append("系統")
                            case 0: //接到 body 裡面的資料，然後再去細分
                                self.userNameToChat.append(test!.body!.entry_notice!.username!)
                                switch test!.body!.entry_notice!.action!{ //body裡面的 action
                                case "enter" :
                                    self.chatArry.append("進入")
                                    //print("我進入")
                                case "leave" :
                                    self.chatArry.append("離開")
                                    //print("離開")
                                                                        
                                default:
                                    print(test!.body!.entry_notice!.username!)
                                }
                            default:
                                print("無法辨識的用戶，錯誤處理")
                            }
                        }catch{
                            print("json error")
                        }
                    default:
                        print("沒有string")
                    }
                }
            //執行緒
            DispatchQueue.main.async {
                self.chatTV.reloadData()
            }
            self.sessionWebSocketTaskReceive()
        }
    }
    
    @IBAction func onEnterClick(_ sender: Any) {
        var chatBoxBtn = chatBox.text ?? " "
        chatBoxBtn.replacingOccurrences(of:" ", with: "")
        print("按鈕\(chatBoxBtn)")
        if chatBoxBtn != ""
        {
            chatArry.append(chatBoxBtn)
            userNameToChat.append(nameID)
            chatBox.text = nil
            self.chatTV.reloadData()
            print(userNameToChat)

        }
        else
        {
           print("空白輸入匡")
        }
    }
    
    // 文字輸入匡
    @IBAction func chatBoxFunction(_ sender: Any) {
        // 如果輸入匡裡面是空值 就不要傳送
        
        
//        guard let chatBox.text == nil else{
//            return nil
//        }
    }
    @IBAction func onLeaveClick(_ sender: Any) {
        
        let alertController = UIAlertController(
               title: "你確定要離開嗎？",
               message: nil,
               preferredStyle: .alert)
        
        let okAction = UIAlertAction(
               title: "確認",
               style: .default,
               handler: { alertAction in
                   self.player?.pause()
                   self.dismiss(animated: true)
               }
        )
        
        let notAction = UIAlertAction(
               title: "取消",
               style: .default,
               handler: nil
        )
        alertController.addAction(notAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private lazy var layer : AVPlayerLayer = {
        let urlMp4 = Bundle.main.url(forResource: "hime3", withExtension: "mp4")
        player = AVPlayer(url: urlMp4! as URL)
        let layer = AVPlayerLayer(player: player)
        return layer
    }()
}
extension liveRoomVC : UITableViewDelegate ,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return chatArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! liveRoomCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // cell不能被選取
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)//對整個tableview翻轉
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)//對cell進行翻轉處理
        let index = chatArry.count - 1 - indexPath.row
        //cell.textViewCell.text = chatArry[index]
        
        cell.textViewCell.text = "\(userNameToChat[index]):\(chatArry[index])"
        
        return cell
    }
    
    
}
extension liveRoomVC :URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
           print("Web socket opened")
        //第一次交握
        sessionWebSocketTaskReceive()
       }

       
       func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
           print("Web socket closed")
       }
}
extension liveRoomVC :UITextFieldDelegate{
    
    // 收鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
 
