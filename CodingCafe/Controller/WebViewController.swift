//
//  WebViewController.swift
//  CodingCafe
//
//  Created by 余佳恆 on 2017/1/22.
//  Copyright © 2017年 icdt. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = UIWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        
        
        let myRequest = URLRequest(url: URL(string: urlString)!);
        
        webView.loadRequest(myRequest);
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
