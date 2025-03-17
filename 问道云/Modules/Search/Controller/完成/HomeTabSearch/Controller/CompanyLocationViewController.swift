//
//  CompanyLocationViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/10.
//

import UIKit
import MapKit

class CompanyLocationViewController: WDBaseViewController {
    
    var name: String = ""
    
    var location: CLLocationCoordinate2D
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.mapType = .hybrid
        return mapView
    }()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = name
        return headView
    }()
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHeadView(from: headView)
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        // 定位到传入的经纬度
        centerMapOnLocation(location: location)
        
        // 添加大头针
        addAnnotation(at: location, name: name)
    }
    
}

extension CompanyLocationViewController: MKMapViewDelegate {
    
    // 将地图中心定位到指定位置
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // 在指定位置添加大头针
    func addAnnotation(at location: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name
        annotation.subtitle = "Lat: \(location.latitude), Lon: \(location.longitude)"
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            
            let label = PaddedLabel()
            label.text = annotation.title ?? ""
            label.textColor = .init(cssStr: "#547AFF")
            label.backgroundColor = .init(cssStr: "#CBD4FF")
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = .mediumFontOfSize(size: 15)
            label.layer.cornerRadius = 4
            label.layer.masksToBounds = true
            label.sizeToFit()
            annotationView?.addSubview(label)
            label.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-40)
                make.centerX.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH * 0.55)
            }
        } else {
            if let label = annotationView?.subviews.first as? UILabel {
                label.text = annotation.title ?? ""
                label.sizeToFit()
            }
        }
        annotationView?.image = UIImage(named: "dingweiiamgell")
        //            annotationView?.image = UIImage(systemName: "mappin.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        return annotationView
    }
    
}
