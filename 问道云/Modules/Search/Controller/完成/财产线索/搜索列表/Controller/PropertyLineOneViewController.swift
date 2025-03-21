//
//  PropertyLineOneViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/21.
//

import UIKit

class PropertyLineOneViewController: WDBaseViewController {
    
    //ID
    var entityId: String = ""
    //名字
    var entityName: String = ""
    //是否被监控
    var monitor: Bool = true
    //logourl
    var logoUrl: String = ""
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 16)
        nameLabel.textAlignment = .left
        return nameLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(logoImageView)
        logoImageView.kf.setImage(with: URL(string: logoUrl), placeholder: UIImage.imageOfText(entityName, size: (29, 29)))
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
