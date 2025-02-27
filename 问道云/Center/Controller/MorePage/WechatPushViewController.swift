//
//  WechatPushViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/15.
//

import UIKit

class WechatPushViewController: WDBaseViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.bgView.backgroundColor = .clear
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "erweimaimge")
        return ctImageView
    }()
    
    lazy var deImageView: UIImageView = {
        let deImageView = UIImageView()
        deImageView.image = UIImage(named: "demoimage")
        return deImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(413)
        }
        scrollView.addSubview(deImageView)
        deImageView.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(340)
            make.height.equalTo(340)
            make.bottom.equalToSuperview()
        }
        addHeadView(from: headView)
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
