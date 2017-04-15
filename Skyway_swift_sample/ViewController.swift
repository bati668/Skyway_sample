//
//  ViewController.swift
//  Skyway_swift_sample
//
//  Created by 千葉大志 on 2017/04/16.
//  Copyright © 2017年 bati. All rights reserved.
//

import UIKit
import GLKit

class ViewController: UIViewController {
    
    let kAPIkey: String = "" // set your api key
    let kDomain: String = "" // set your domain
    
    var party: MultiParty?
    var peer: SKWPeer?
    
    var remoteStream: SKWMediaStream?
    var localStream: SKWMediaStream?
    var remoteStreams: [SKWMediaStream] = [SKWMediaStream]()
    
    var localVideo: SKWVideo! // localのカメラ(自分が映る)
    var remoteVideosArray: [SKWVideo] = [SKWVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let opition: MultiPartyOption = MultiPartyOption()
        opition.key = kAPIkey
        opition.domain = kDomain
        opition.debug = .MP_DEBUG_LEVEL_ERROR_AND_WARNING
        opition.room = "test_room"
        
        party = MultiParty(option: opition)
        
        self.registerMultiPartyEvents()
        
        party?.start()
        
        localVideo = SKWVideo()
        localVideo.setMirrorViewing(true)
        
        // localVideoのsize
        let localVideoSize: CGSize = CGSize(width: 200, height: 200)
        
        //右下に配置
        localVideo.frame = CGRect(x: self.view.frame.size.width - localVideoSize.width - 15.0,
                                  y: self.view.frame.size.height - localVideoSize.height - 15.0,
                                  width: localVideoSize.width,
                                  height: localVideoSize.height)
        self.view.addSubview(localVideo)
        
        localVideo.backgroundColor = UIColor.clear
    }
    
    // Eventを登録する
    func registerMultiPartyEvents() {
        
        // SkyWayサーバとのコネクションが確立
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_OPEN) { (dic) in
            
        }
        
        //自分ののvideo/audioストリームのセットアップが完了
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_MY_MS) { (dic) in
            
            // SKWMediaStream, id帰ってくる
            let stream: SKWMediaStream? = dic?["src"] as? SKWMediaStream
            
            // ローカルストリームをsetして,localVideoにaddすると、ローカルカメラに映像が出る
            self.localStream = stream
            if let s = self.localStream {
                self.localVideo.addSrc(s, track: 0)
            }
        }
        
        
        //peerのvideo/audioストリームのセットアップが完了。
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_PEER_MS) { (dic) in
            DispatchQueue.main.async {
                let remoteFrameXStart = self.remoteVideosArray.count * 110
                let remoteVideo: SKWVideo = SKWVideo()
                remoteVideo.frame = CGRect(x: remoteFrameXStart, y: 10, width: 100, height: 100)
                self.remoteVideosArray.append(remoteVideo)
                self.view.addSubview(remoteVideo)
                self.updateUI()
                
                // remoteの mediaStreamが帰ってくる
                let stream: SKWMediaStream? = dic?["src"] as? SKWMediaStream
                if let s = stream {
                    self.remoteStreams.append(s)
                    remoteVideo.addSrc(s, track: 0)
                }
            }
        }
        
        // peerのメディアストリームがクローズした際に発生します。
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_MS_CLOSE) { (dic) in
            
            // closeしたstreamが帰ってくる
            let stream: SKWMediaStream? = dic?["src"] as? SKWMediaStream
            
            // closeしたstreamをvideoからremoveしてあげよう。グループ通話の場合は、例えば同じIDのmedia streamをremoveしてあげよう
            if let s = stream {
                //                self.remoteVideo.removeSrc(s, track: 0)
            }
        }
        
        //peerのスクリーンキャプチャストリームのセットアップが完了
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_PEER_SS) { (dic) in
            
        }
        
        // peerのメディアストリームがクローズした
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_SS_CLOSE) { (dic) in
            
        }
        
        // データチャンネルのコネクションのセットアップが完了した際に発生します。
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_DC_OPEN) { (dic) in
            
        }
        
        // peerからメッセージを受信した際に発生します。
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_MESSAGE) { (dic) in
            
        }
        
        // データコネクションがクローズした
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_DC_CLOSE) { (dic) in
            
        }
        
        // エラー
        party?.on(MultiPartyEventEnum.MULTIPARTY_EVENT_ERROR) { (dic) in
            
            
        }
    }
    
    // 何かUI udpateするときなど、main Queでupdate
    func updateUI() {
        DispatchQueue.main.async {
            
        }
    }
}


