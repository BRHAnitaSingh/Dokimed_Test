//
//  WebPageVC.swift
//  Lex
//
//  Created by Chawtech on 23/05/22.
//

import UIKit
import WebKit


class WebPageVC: UIViewController,WKUIDelegate,WKNavigationDelegate {

// MARK: IBOutlets
    
    @IBOutlet weak var webPaegView: WKWebView!
    @IBOutlet weak var viewWeb: UIView!
    
    // MARK: Variables
    
    var urlStr = String()
    var webView: WKWebView!

   

    override func viewDidLoad() {
        super.viewDidLoad()
        webPaegView.navigationDelegate = self
//        showProgressOnView(appDelegateInstance.window!)

        let url = URL(string: urlStr)
//        let searchURL : NSURL = NSURL(string:"https://www.google.com/?client=safari")!
        if url != nil{
            let requestObj = URLRequest(url: url! as URL)
//            let requestObj = URLRequest(url: searchURL as URL)
            webPaegView.load(requestObj)
        }
        
//        self.dsa()
    }
    
//    override func loadView() {
//            let webConfiguration = WKWebViewConfiguration()
//    //        webView = WKWebView(frame: .init(x: 20, y: 70, width: 335, height: 577), configuration: webConfiguration)
//            webView = WKWebView(frame: .init(x: 20, y: 70, width: 335, height: 577), configuration: webConfiguration)
//            webView.uiDelegate = self
//            view = webView
//        }
//    public func dsa() {
//
//        let url : NSString = self.urlStr as NSString
//        let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
//        let searchURL : NSURL = NSURL(string:"https://www.google.com/?client=safari")!
//
////        let url = URL (string:"http://34.220.107.44/LukeLearning/File/1602595211598PbkQyAte.jpeg")
////        //  let url = URL (string:"http://155.138.205.250:8081/app/account#/login")
//        let requestObj = URLRequest(url: searchURL as URL)
//        webView.load(requestObj)
//
//
////        webView.navigationDelegate = self
//    }
    func webView(_webView: WKWebView, didFinish navigation:WKNavigation!){
        DispatchQueue.main.async {
            hideAllProgressOnView(appDelegateInstance.window!)
        }
    }
    func webView(_webView: WKWebView, didFailProvisionNavigation navigation:WKNavigation!, withError error: Error){
        DispatchQueue.main.async {
            hideAllProgressOnView(appDelegateInstance.window!)
        }
    }

}
