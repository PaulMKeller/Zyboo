//
//  NewsViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 11/9/18.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {
    
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         let urlString = "www.zyboo.org"
         let myRequest = URLRequest(url: URL(string: urlString)!)
         self.webView.load(myRequest)
 
        
        /*
        let stringUrl = "http://www.zyboo.org/blog/"
        if let encodedURL = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedURL) {
            self.webView.load(URLRequest(url: url))
        }
        */
        
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                activityIndicator.stopAnimating()
            }
        }
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
