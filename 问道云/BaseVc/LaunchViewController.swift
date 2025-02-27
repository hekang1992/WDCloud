//
//  LaunchViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//

import UIKit

class LaunchViewController: WDBaseViewController {
    
    lazy var homeBgImageView: UIImageView = {
        let homeBgImageView = UIImageView()
        homeBgImageView.image = UIImage(named: "homelacunchimage")
        homeBgImageView.contentMode = .scaleAspectFit
        return homeBgImageView
    }()
    
    lazy var priImageView: UIImageView = {
        let priImageView = UIImageView()
        priImageView.backgroundColor = .random()
        priImageView.image = UIImage(named: "apppriimage")
        priImageView.contentMode = .scaleAspectFit
        return priImageView
    }()
    
    var isShow: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(homeBgImageView)
        view.addSubview(priImageView)
        homeBgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        priImageView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize(width: 310, height: 385))
//        }
        NetworkManager.shared.startListening()
    }
    
}
