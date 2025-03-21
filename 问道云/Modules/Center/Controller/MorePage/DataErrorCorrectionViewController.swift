//
//  DataErrorCorrectionViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/17.
//

import UIKit
import RxRelay
import Photos
import RxSwift

class DataErrorCorrectionViewController: WDBaseViewController {
    
    //参数
    var abountfirm = BehaviorRelay<String>(value: "")
    var aboutfunction = BehaviorRelay<String>(value: "")
    var question = BehaviorRelay<String>(value: "")
    var tel = BehaviorRelay<String>(value: "")
    var handleby = BehaviorRelay<String>(value: "")
    var pics = BehaviorRelay<[String]>(value: [])
    var feedbacktype = BehaviorRelay<String>(value: "5")
    
    var picsArray: [String] = []
    
    var count: Int = 0
    
    let placeholderText = "请填写10个字以上的问题描述，以便我们提供更好的服务。"
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "数据纠错"
        return headView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        let title = "企业名称 *"
        oneLabel.textColor = .init(cssStr: "#333333")
        oneLabel.font = .mediumFontOfSize(size: 14)
        oneLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        oneLabel.textAlignment = .left
        return oneLabel
    }()
    
    lazy var nameTx: UITextField = {
        let nameTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入企业名称", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        nameTx.attributedPlaceholder = attrString
        nameTx.font = UIFont.regularFontOfSize(size: 14)
        nameTx.textColor = UIColor.init(cssStr: "#333333")
        nameTx.leftView = UIView(frame: CGRectMake(0, 0, 5, 20))
        nameTx.leftViewMode = .always
        nameTx.layer.cornerRadius = 5
        nameTx.layer.borderWidth = 1
        nameTx.layer.borderColor = UIColor.init(cssStr: "#D6D6D6")?.cgColor
        return nameTx
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .white
        return twoView
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        let title = "纠错模块 *"
        twoLabel.textColor = .init(cssStr: "#333333")
        twoLabel.font = .mediumFontOfSize(size: 14)
        twoLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        twoLabel.textAlignment = .left
        return twoLabel
    }()
    
    lazy var blockTx: UITextField = {
        let blockTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入模块名称", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        blockTx.attributedPlaceholder = attrString
        blockTx.font = UIFont.regularFontOfSize(size: 14)
        blockTx.textColor = UIColor.init(cssStr: "#333333")
        blockTx.textAlignment = .right
        return blockTx
    }()
    
    lazy var threeView: UIView = {
        let threeView = UIView()
        threeView.backgroundColor = .white
        return threeView
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        let title = "问题模块 *"
        threeLabel.textColor = .init(cssStr: "#333333")
        threeLabel.font = .mediumFontOfSize(size: 14)
        threeLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        threeLabel.textAlignment = .left
        return threeLabel
    }()
    
    lazy var enterView: UITextView = {
        let enterView = UITextView()
        enterView.delegate = self
        enterView.font = .regularFontOfSize(size: 13)
        enterView.text = placeholderText
        enterView.textColor = UIColor.init(cssStr: "#9FA4AD")
        enterView.layer.cornerRadius = 5
        enterView.layer.borderWidth = 1
        enterView.layer.borderColor = UIColor.init(cssStr: "#D6D6D6")?.cgColor
        return enterView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.text = "0/500"
        numLabel.textColor = .init(cssStr: "#9FA4AD")
        numLabel.font = .mediumFontOfSize(size: 13)
        numLabel.textAlignment = .right
        return numLabel
    }()
    
    lazy var fourView: UIView = {
        let fourView = UIView()
        fourView.backgroundColor = .white
        return fourView
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        let title = "联系电话 *"
        fourLabel.textColor = .init(cssStr: "#333333")
        fourLabel.font = .mediumFontOfSize(size: 14)
        fourLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        fourLabel.textAlignment = .left
        return fourLabel
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入联系电话", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = UIFont.regularFontOfSize(size: 14)
        phoneTx.textColor = UIColor.init(cssStr: "#333333")
        phoneTx.textAlignment = .right
        return phoneTx
    }()
    
    lazy var fiveView: UIView = {
        let fiveView = UIView()
        fiveView.backgroundColor = .white
        return fiveView
    }()
    
    lazy var fiveLabel: UILabel = {
        let fiveLabel = UILabel()
        let title = "上传凭证"
        fiveLabel.textColor = .init(cssStr: "#333333")
        fiveLabel.font = .mediumFontOfSize(size: 14)
        fiveLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        fiveLabel.textAlignment = .left
        return fiveLabel
    }()
    
    lazy var descoLabel: UILabel = {
        let descoLabel = UILabel()
        descoLabel.text = "请上传相关证明图片或公开渠道信息截图，最多4张"
        descoLabel.textColor = .init(cssStr: "#9FA4AD")
        descoLabel.textAlignment = .left
        descoLabel.font = .regularFontOfSize(size: 12)
        return descoLabel
    }()
    
    lazy var uploadBtn: UIButton = {
        let uploadBtn = UIButton(type: .custom)
        uploadBtn.setImage(UIImage(named: "uploadingeadd"), for: .normal)
        return uploadBtn
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        return fourImageView
    }()
    
    lazy var cImageView: UIImageView = {
        let cImageView = UIImageView()
        cImageView.image = UIImage(named: "dataerrorimagejiu")
        return cImageView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton(type: .custom)
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.layer.cornerRadius = 3
        submitBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        submitBtn.backgroundColor = .init(cssStr: "#B2C3FF")
        submitBtn.isEnabled = false
        return submitBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(oneView)
        oneView.addSubview(oneLabel)
        oneView.addSubview(nameTx)
        
        view.addSubview(twoView)
        twoView.addSubview(twoLabel)
        twoView.addSubview(blockTx)
        
        view.addSubview(threeView)
        threeView.addSubview(threeLabel)
        threeView.addSubview(enterView)
        threeView.addSubview(numLabel)
        
        view.addSubview(fourView)
        fourView.addSubview(fourLabel)
        fourView.addSubview(phoneTx)
        
        view.addSubview(fiveView)
        fiveView.addSubview(fiveLabel)
        fiveView.addSubview(descoLabel)
        fiveView.addSubview(oneImageView)
        fiveView.addSubview(twoImageView)
        fiveView.addSubview(threeImageView)
        fiveView.addSubview(fourImageView)
        fiveView.addSubview(uploadBtn)
        
        view.addSubview(cImageView)
        view.addSubview(submitBtn)
        
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(82)
        }
        oneLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
        }
        nameTx.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalTo(oneLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(16)
        }
        
        twoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom).offset(4)
            make.height.equalTo(45)
        }
        twoLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
        }
        blockTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        
        threeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom).offset(4)
            make.height.equalTo(150)
        }
        threeLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
        }
        enterView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(101)
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(threeLabel.snp.bottom).offset(6)
        }
        numLabel.snp.makeConstraints { make in
            make.height.equalTo(16.5)
            make.bottom.equalToSuperview().offset(-13.5)
            make.right.equalToSuperview().offset(-24)
        }
        
        fourView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(threeView.snp.bottom).offset(4)
            make.height.equalTo(45)
        }
        fourLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
        }
        phoneTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        fiveView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(fourView.snp.bottom).offset(4)
            make.height.equalTo(140)
        }
        fiveLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
        }
        descoLabel.snp.makeConstraints { make in
            make.left.equalTo(fiveLabel.snp.left)
            make.top.equalTo(fiveLabel.snp.bottom).offset(4.5)
            make.right.equalToSuperview().offset(-12)
        }
        oneImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(descoLabel.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        twoImageView.snp.makeConstraints { make in
            make.left.equalTo(oneImageView.snp.right).offset(2)
            make.top.equalTo(oneImageView.snp.top)
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        threeImageView.snp.makeConstraints { make in
            make.left.equalTo(twoImageView.snp.right).offset(2)
            make.top.equalTo(oneImageView.snp.top)
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        fourImageView.snp.makeConstraints { make in
            make.left.equalTo(threeImageView.snp.right).offset(2)
            make.top.equalTo(oneImageView.snp.top)
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        uploadBtn.snp.makeConstraints { make in
            make.left.equalTo(fourImageView.snp.right)
            make.top.equalTo(oneImageView.snp.top)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        cImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fiveView.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 342, height: 43))
        }
        
        submitBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40.pix())
            make.left.equalToSuperview().offset(45)
            make.bottom.equalToSuperview().offset(-50)
        }
        
//        var abountfirm = BehaviorRelay<String>(value: "")
//        var aboutfunction = BehaviorRelay<String>(value: "")
//        var question = BehaviorRelay<String>(value: "")
//        var tel = BehaviorRelay<String>(value: "")
//        var handleby = BehaviorRelay<String>(value: "")
//        var pics = BehaviorRelay<[String]>(value: [])
//        var feedbacktype = BehaviorRelay<String>(value: "5")
        
        //点击,获取相册权限
        uploadBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.checkPhotoLibraryPermission()
        }).disposed(by: disposeBag)
        
        self.nameTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.abountfirm.accept(self.nameTx.text ?? "")
            }).disposed(by: disposeBag)
        
        self.blockTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.aboutfunction.accept(self.blockTx.text ?? "")
            }).disposed(by: disposeBag)
        
        self.phoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.tel.accept(self.phoneTx.text ?? "")
            }).disposed(by: disposeBag)
        
        let combine = Observable.combineLatest(abountfirm, aboutfunction, question, tel, handleby, pics, feedbacktype)
        combine.map { [weak self] (abountfirm, aboutfunction, question, tel, handleby, [String], feedbacktype) in
            let grand = !abountfirm.isEmpty && !aboutfunction.isEmpty && !question.isEmpty && !tel.isEmpty
            if grand {
                self?.submitBtn.backgroundColor = .init(cssStr: "#547AFF")
            }else {
                self?.submitBtn.backgroundColor = .init(cssStr: "#B2C3FF")
            }
            return grand
        }.bind(to: submitBtn.rx.isEnabled).disposed(by: disposeBag)
        
        submitBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.submitInfo()
        }).disposed(by: disposeBag)
    }

}

extension DataErrorCorrectionViewController: UITextViewDelegate {
    
    func submitInfo() {
        
        let abountfirm = self.abountfirm.value
        let aboutfunction = aboutfunction.value
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let feedbacktype = self.feedbacktype.value
        
        let handleby = GetSaveLoginInfoConfig.getPhoneNumber()
       
        let pic = self.pics.value.description
        let question = question.value
        let tel = self.tel.value
        
        let dict = ["abountfirm": abountfirm,
                    "aboutfunction": aboutfunction,
                    "customernumber": customernumber,
                    "feedbacktype": feedbacktype,
                    "handleby": handleby,
                    "pic": pic,
                    "question": question,
                    "tel": tel] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/operationFeedback",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    ToastViewConfig.showToast(message: "提交成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            openPhotoLibrary()
        case .denied, .restricted:
            print("未授权，无法访问相册")
            ShowAlertManager.showAlert(title: "相册权限", message: "请在设置中启用相册权限以便您可以上传截图。", confirmAction: { [weak self] in
                self?.openSettings()
            })
        case .notDetermined:
            print("未决定，请求权限")
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    print("用户已授权")
                    self.openPhotoLibrary()
                } else {
                    self.openSettings()
                }
            }
        case .limited:
            print("部分授权（iOS 14+）")
        @unknown default:
            print("未知状态")
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Photo library is not available")
        }
    }
    
    func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                    if success {
                        print("成功跳转到设置页面")
                    } else {
                        print("跳转失败")
                    }
                })
            } else {
                print("无法打开设置页面")
            }
        }
    }
    
    // 开始编辑时隐藏 placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    // 结束编辑时显示 placeholder（如果内容为空）
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.init(cssStr: "#9FA4AD")
        }else {
            self.question.accept(textView.text ?? "")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 500
    }
    
    // 实时更新剩余字符数
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
    }
    
    // 更新字符数显示
    func updateCharacterCount() {
        let currentText = enterView.text ?? ""
        numLabel.text = "\(currentText.count)/500"
    }
    
}

extension DataErrorCorrectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // 处理选中的图片，例如上传到服务器
            uploadImage(image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage) {
        // 在这里实现图片上传逻辑
        let man = RequestManager()
        let dict = ["orgnumber": "200"]
        let data = image.jpegData(compressionQuality: 0.8)!
        man.uploadImageAPI(params: dict, pageUrl: "/file/upload", data: data, method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if let self = self,
                    let model = success.data,
                    let code = success.code,
                    code == 200 {
                    count += 1
                    self.changUI(from: model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func changUI(from model: DataModel) {
        picsArray.append(model.url ?? "")
        self.pics.accept(picsArray)
        if count == 1 {
            self.oneImageView.snp.updateConstraints { make in
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            self.oneImageView.kf.setImage(with: URL(string: model.url ?? ""))
        } else if count == 2 {
            self.twoImageView.snp.updateConstraints { make in
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            self.twoImageView.kf.setImage(with: URL(string: model.url ?? ""))
        } else if count == 3 {
            self.threeImageView.snp.updateConstraints { make in
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            self.threeImageView.kf.setImage(with: URL(string: model.url ?? ""))
        } else if count == 4 {
            self.uploadBtn.isHidden = true
            self.fourImageView.snp.updateConstraints { make in
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            self.fourImageView.kf.setImage(with: URL(string: model.url ?? ""))
        }
    }
    
}
