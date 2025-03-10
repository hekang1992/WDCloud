//
//  AboutUsViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/13.
//

import UIKit

class AboutUsViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "关于我们"
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "launchlogo")
        
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.top.equalTo(headView.snp.bottom).offset(32)
        }
        
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 18)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            mlabel.text = "问道云 V\(version)"
        }
        view.addSubview(mlabel)
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(15)
            make.height.equalTo(25)
        }
        
        let desclabel = UILabel()
        desclabel.numberOfLines = 0
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 12)
        desclabel.text = "上海问道云人工智能科技有限公司是一家专注于人工智能与大数据技木融合，为企业提供深度数据洞察与智能决策支持的创新型科技企业。公司凭借强大的大数据算力和领先的人工智能技术，为企业用户提供精准、高效、智能的信息查询与分析服务，助力企业洞察市场趋势，实现数智化、科学决策。公司在上海、北京、深圳建立研发团队，通过不断创新、持续迭代，为用户提供最优质的服务。\n\n问道云是由上海问道云人工智能科技有限公司开发并运营的企业信息综合查询平台，致力于为企事业单位、机关尤其是政法系统、金融行业、广大企业和相关人士提供全面、准确、高效的企业信息检索服务，全方位分析评估、预警防范、处置化解各类风险，助力企业和经济高质量发展。\n\n问道云基于团队创始人丰富的应用理念、实践和团队超强的研发实力，构建了完备的数据采集、数据清洗、数据建模、数据融合、数据产品一体化的大数据应用平台；基于政府公开等数据，综合运用人工智能、大数据、云计算等技术，开发了企业信息智能查询、企业风险智能预警、企业风险智能监控、企业舆情智能检测、智能尽职调查、一键报告、求职检测等多功能模块，在线提供全国各类企业、团体信息，并多维度、多视角分析评估相关数据，为投资决策、商务合作、法律服务等相关企业和人士提供便捷、高效、精准的企业信息调查和风险监控预警服务。"
        view.addSubview(desclabel)
        desclabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(mlabel.snp.bottom).offset(28)
        }
    }

}
