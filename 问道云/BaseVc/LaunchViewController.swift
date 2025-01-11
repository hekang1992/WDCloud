//
//  LaunchViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/11.
//

import UIKit

class LaunchViewController: WDBaseViewController {
    
    lazy var homeBgImageView: UIImageView = {
        let homeBgImageView = UIImageView()
        homeBgImageView.image = UIImage(named: "homelacunchimage")
        homeBgImageView.contentMode = .scaleAspectFill
        return homeBgImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(homeBgImageView)
        homeBgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NetworkManager.shared.startListening()
        
    }
    
}
