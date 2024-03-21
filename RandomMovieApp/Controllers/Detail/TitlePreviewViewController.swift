//
//  TitlePreviewViewController.swift
//  RandomMovieApp
//
//  Created by Fatih Yörük on 7.03.2024.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    private let webViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
    
    private func setUpView() {
        view.backgroundColor = .main
        view.addSubview(webViewContainerView)
        webViewContainerView.addSubview(webView)
    }

    private func setUpConstraints() {
        webViewContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        webView.snp.makeConstraints { make in
            make.edges.equalTo(webViewContainerView)
        }
    }
    
    public func configureWebView(with url: URL) {
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            self.webView.load(request)
        }
    }
}

