//
//  AboutViewController.swift
//  CodingCafe
//
//  Created by 余佳恆 on 2017/1/20.
//  Copyright © 2017年 icdt. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var label_Version: UILabel!
    
    
    var array_CafeNomad = ["開源資料是由台灣各地的 cafe nomad 社群，一起整理的咖啡廳清單與地圖。",
                           "Cafe Nomad 粉絲專頁",
                           "Cafe Nomad 官方網站",]
    var array_CafeNomadImage = ["",
                                "iconShapeFB",
                                "iconShapeWorld",]
    
    var array_Author = [" IOS UI 設計 ：Una \n IOS APP 作者 ：巧克力 \n 目前任職於Dakuo數創中心的資雲數位 歡迎來找我泡茶聊天",
                        "回報問題",
                        "Github",
                        "給好評"]
    
    var array_AuthorImage = ["",
                            "iconShapeMail",
                            "iconShapeWorld",
                            "iconShapeStar"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = imageView.frame
        frame.origin.y = navigationController!.navigationBar.frame.maxY
        imageView.frame = frame
        
        frame = tableView.frame
        frame.origin.y = imageView.frame.maxY
        tableView.frame = frame
        
        imageView.backgroundColor = UIColor.brown
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.footerView(forSection: .allZeros)
        tableView.separatorInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        tableView.tableHeaderView?.backgroundColor = UIColor.darkGray

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        label_Version.text = "v \(version!)"
        label_Version.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return array_CafeNomad.count
        case 1:
            return array_Author.count
        default:
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = array_CafeNomad[indexPath.row]
            cell.imageView?.image = UIImage(named: array_CafeNomadImage[indexPath.row])
        case 1:
            cell.textLabel?.text = array_Author[indexPath.row]
            cell.imageView?.image = UIImage(named: array_AuthorImage[indexPath.row])
            
        default:
            break
        }
        
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 5
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 1:
            return 10 / 667 * self.view.bounds.height
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WebViewController()
        
        switch indexPath.section {

        case 0:
            
            switch indexPath.row {
            case 1:
                vc.urlString = "https://www.facebook.com/cafenomad.tw/"
            case 2:
                vc.urlString = "https://cafenomad.tw/"
            default:
                break
            }
        
        case 1:
            
            switch indexPath.row {
            case 1:
                mail()
                break
            case 2:
                vc.urlString = "https://github.com/nurockplayer/CodingCafe"
            case 3:
                vc.urlString = ""
            default:
                break
            }
        default:
            break
        }
        
        if vc.urlString != "" {
            show(vc, sender: nil)
        }
    }
    
    
    func mail() {
        let mailComposerVC = MFMailComposeViewController()
        
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["nurockplayer@gmail.com"])
        mailComposerVC.setSubject("找咖啡意見反饋")
        mailComposerVC.setMessageBody("機型： \n 系統版本：", isHTML: false)
        
        show(mailComposerVC, sender: nil)
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        <#code#>
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
