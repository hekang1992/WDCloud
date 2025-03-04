//
//  OpinioUpLoadViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/14.
//

import UIKit
import Photos
import RxRelay
import RxSwift

class OpinioUpLoadViewController: WDBaseViewController {
    
    //参数
    var oneStr = BehaviorRelay<String>(value: "")
    var pics = BehaviorRelay<[String]>(value: [])
    var phone = BehaviorRelay<String>(value: "")
    var feedbacktype = BehaviorRelay<String>(value: "")
    var feedbacksubtype = BehaviorRelay<String>(value: "")
    
    var picsArray: [String] = []
    
    var questionTitle: String?
    
    let placeholderText = "请填写10个字以上的问题描述，以便我们提供更好的服务。"
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "意见反馈"
        return headView
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.text = questionTitle
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 11)
        return desclabel
    }()
    
    lazy var oneWhiteView: UIView = {
        let oneWhiteView = UIView()
        oneWhiteView.backgroundColor = .white
        return oneWhiteView
    }()
    
    lazy var twoWhiteView: UIView = {
        let twoWhiteView = UIView()
        twoWhiteView.backgroundColor = .white
        return twoWhiteView
    }()
    
    lazy var threeWhiteView: UIView = {
        let threeWhiteView = UIView()
        threeWhiteView.backgroundColor = .white
        return threeWhiteView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        let title = "* 问题描述:"
        oneLabel.textColor = .init(cssStr: "#333333")
        oneLabel.font = .mediumFontOfSize(size: 14)
        oneLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        oneLabel.textAlignment = .left
        return oneLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.text = "0/500"
        numLabel.textColor = .init(cssStr: "#9FA4AD")
        numLabel.font = .mediumFontOfSize(size: 13)
        numLabel.textAlignment = .right
        return numLabel
    }()
    
    lazy var tView: UITextView = {
        let tView = UITextView()
        tView.delegate = self
        tView.font = .regularFontOfSize(size: 13)
        tView.text = placeholderText
        tView.textColor = UIColor.init(cssStr: "#9FA4AD")
        return tView
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.text = "上传凭证（提供问题截图）"
        twoLabel.textColor = .init(cssStr: "#333333")
        twoLabel.textAlignment = .left
        twoLabel.font = .mediumFontOfSize(size: 14)
        return twoLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var descoLabel: UILabel = {
        let descoLabel = UILabel()
        descoLabel.text = "请上传相关证明图片，或公开渠道信息截图，支持JPG、JPEG、PNG格式，每张不超过5M，最多可上传4张。"
        descoLabel.numberOfLines = 0
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
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        let title = "* 联系电话:"
        threeLabel.textColor = .init(cssStr: "#333333")
        threeLabel.font = .mediumFontOfSize(size: 14)
        threeLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        threeLabel.textAlignment = .left
        return threeLabel
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入联系方式", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = UIFont.regularFontOfSize(size: 14)
        phoneTx.textColor = UIColor.init(cssStr: "#333333")
        return phoneTx
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton(type: .custom)
        submitBtn.setTitle("提交反馈", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.layer.cornerRadius = 3
        submitBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        submitBtn.backgroundColor = .init(cssStr: "#B2C3FF")
        submitBtn.isEnabled = false
        return submitBtn
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
    
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        addHeadView(from: headView)
        view.addSubview(desclabel)
        view.addSubview(oneWhiteView)
        view.addSubview(submitBtn)
        
        oneWhiteView.addSubview(oneLabel)
        oneWhiteView.addSubview(tView)
        oneWhiteView.addSubview(numLabel)
        
        view.addSubview(twoWhiteView)
        twoWhiteView.addSubview(twoLabel)
        twoWhiteView.addSubview(scrollView)
        
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        scrollView.addSubview(threeImageView)
        scrollView.addSubview(fourImageView)
        
        scrollView.addSubview(uploadBtn)
        
        twoWhiteView.addSubview(descoLabel)
        
        view.addSubview(threeWhiteView)
        threeWhiteView.addSubview(threeLabel)
        threeWhiteView.addSubview(phoneTx)
        
        desclabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12.5)
        }
        
        oneWhiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(desclabel.snp.bottom).offset(10)
            make.height.equalTo(145.5)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        
        numLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        tView.snp.makeConstraints { make in
            make.left.equalTo(oneLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(oneLabel.snp.bottom).offset(7)
            make.bottom.equalTo(numLabel.snp.top).offset(-2)
        }
        
        twoWhiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneWhiteView.snp.bottom).offset(4)
            make.height.equalTo(174.5)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(twoLabel.snp.bottom).offset(6)
            make.left.equalTo(twoLabel.snp.left)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.height.equalTo(70)
        }
        
        oneImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        twoImageView.snp.makeConstraints { make in
            make.left.equalTo(oneImageView.snp.right).offset(2)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        threeImageView.snp.makeConstraints { make in
            make.left.equalTo(twoImageView.snp.right).offset(2)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        fourImageView.snp.makeConstraints { make in
            make.left.equalTo(threeImageView.snp.right).offset(2)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        uploadBtn.snp.makeConstraints { make in
            make.left.equalTo(fourImageView.snp.right).offset(2)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.right.equalToSuperview().offset(-5)
        }
        descoLabel.snp.makeConstraints { make in
            make.left.equalTo(twoLabel.snp.left)
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-8)
        }
        
        threeWhiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoWhiteView.snp.bottom).offset(4)
            make.height.equalTo(84)
        }
        threeLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        phoneTx.snp.makeConstraints { make in
            make.left.equalTo(threeLabel.snp.left)
            make.top.equalTo(threeLabel.snp.bottom).offset(2)
            make.size.equalTo(CGSize(width: 250, height: 40))
        }
        
        submitBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(43)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-34)
        }
        
        //点击,获取相册权限
        uploadBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.checkPhotoLibraryPermission()
            }
        }).disposed(by: disposeBag)
        
        let combine = Observable.combineLatest(oneStr, pics, phone, feedbacktype, feedbacksubtype)
        combine.map { [weak self] (ontstr, pisc, phone, feedbacktype, feedbacksubtype) in
            let grand = !ontstr.isEmpty && !pisc.isEmpty && !phone.isEmpty && !feedbacktype.isEmpty
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
        
        phoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.phone.accept(self.phoneTx.text ?? "")
            }).disposed(by: disposeBag)
        
    }
    
}

extension OpinioUpLoadViewController: UITextViewDelegate {
    
    func submitInfo() {
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let question = self.oneStr.value
        let tel = self.phone.value
        let feedbacktype = self.feedbacktype.value
        let feedbacksubtype = self.feedbacksubtype.value
        let pic = self.pics.value.description
        
        let dict = ["customernumber": customernumber,
                    "question": question,
                    "tel": tel,
                    "feedbacktype": feedbacktype,
                    "feedbacksubtype": feedbacksubtype,
                    "pic": pic] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/operationFeedback",
                       method: .post) { result in
            ViewHud.hideLoadView()
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
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.openPhotoLibrary()
            }
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
                    DispatchQueue.main.async {
                        self.openPhotoLibrary()
                    }
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
            self.oneStr.accept(textView.text ?? "")
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
        let currentText = tView.text ?? ""
        numLabel.text = "\(currentText.count)/500"
    }
    
}

extension OpinioUpLoadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["orgnumber": "200"]
        let data = image.jpegData(compressionQuality: 0.8)!
        man.uploadImageAPI(params: dict, pageUrl: "/file/upload", data: data, method: .post) { [weak self] result in
            ViewHud.hideLoadView()
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
                make.left.equalToSuperview()
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
