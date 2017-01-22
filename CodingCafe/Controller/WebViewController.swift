//
//  WebViewController.swift
//  CodingCafe
//
//  Created by 余佳恆 on 2017/1/22.
//  Copyright © 2017年 icdt. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var urlString = ""
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let webView = UIWebView(frame: self.view.frame)
        webView.delegate = self
        self.view.addSubview(webView)
        
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.sizeToFit()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        let myRequest = URLRequest(url: URL(string: urlString)!);
        webView.loadRequest(myRequest);
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        activityIndicator.stopAnimating()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
