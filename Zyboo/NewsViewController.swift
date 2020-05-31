//
//  NewsViewController.swift
//  Zyboo
//
//  Created by Paul Keller on 11/9/18.
//  Copyright © 2018 PlanetKGames. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        
        view.addSubview(activityIndicator)
        let basePage = "<html><head></head><body><h1>Loading Zyboo. Please wait...</h1><h1>If you want to contact us please send an email to <a href='mailto:contact@zyboo.org?Subject=Support Issue' target='_top'>contact@zyboo.org</a></h1></body></html>"
        webView.loadHTMLString(basePage, baseURL: Bundle.main.bundleURL)
        
        if Reachability.isConnectedToNetwork() {
            let url = URL(string: "http://www.zyboo.org")!
            let request = URLRequest(url: url)
            webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    //Implement 404 response handle to revert to a safe page. Not working...
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let basePage = "<html><head></head><body><h1>There's a problem with the website at the moment.</h1><h1>We're working on it but it won't stop you using the app don't worry!</h1></body></html>"
        webView.loadHTMLString(basePage, baseURL: Bundle.main.bundleURL)
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
