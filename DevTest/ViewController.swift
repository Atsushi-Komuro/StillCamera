//
//  ViewController.swift
//  sousa
//
//  Created by Misato Morino on 2015/08/14.
//  Copyright (c) 2015年 Atsushi Komuro. All rights reserved.
//  参考：
//    ・https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/3-avfoundation/002-kamerano-qi-dongto-hua-xiangno-bao-cun
//  　 ・開発のプロが教えるSwift標準ガイドブック
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    //セッション
    var CapSession : AVCaptureSession!
    //デバイス
    var CapDevice : AVCaptureDevice!
    //画像アウト
    var ImageOut : AVCaptureStillImageOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CapSession = AVCaptureSession()
        let devices = AVCaptureDevice.devices()
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                CapDevice = device as! AVCaptureDevice
            }
        }
        
        //VideoInputを取得、セッションに追加
        do{
            let videoInput = try AVCaptureDeviceInput(device: CapDevice)
            CapSession.addInput(videoInput)
        }catch{
            
        }
        
        //出力先を生成
        ImageOut = AVCaptureStillImageOutput()
        
        //セッションに追加
        CapSession.addOutput(ImageOut)
        
        //画像を表示するレイヤーを生成
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: CapSession!) as AVCaptureVideoPreviewLayer
        
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        // Viewに追加
        self.view.layer.addSublayer(videoLayer)
        
        //セッション開始
        CapSession.startRunning()
        
        //UIボタンを作成
        let Btn = UIButton(frame: CGRectMake(0,0,120,50))
        Btn.backgroundColor = UIColor.redColor()
        Btn.layer.masksToBounds = true
        Btn.setTitle("Take", forState: .Normal)
        Btn.layer.cornerRadius = 20.0
        Btn.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-50)
        Btn.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        //UIボタンをViewに追加
        self.view.addSubview(Btn)
    }
    
    //ボタンイベント
    func onClickMyButton(sender: UIButton){
        //ビデオ出力に接続
        let videoConnection = ImageOut.connectionWithMediaType(AVMediaTypeVideo)
        
        //接続から画像を取得
        self.ImageOut.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler:
            {(imageDataBuffer: CMSampleBuffer?, error:NSError?)->Void in
                if(imageDataBuffer == nil){
                    //completion!(image:nil,error:error)
                }
                
                //取得したImageのDataBufferをJpegに変換
                let imageData: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                
                //JpegからUIImageを作成
                let image : UIImage = UIImage(data: imageData)!
                
                //アルバムに追加
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }
        )
    }
}