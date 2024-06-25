//
//  HGLocation.swift
//

import UIKit
import CoreLocation

public class HGLocation: NSObject {
    
    public static let shared = HGLocation()
    
    public typealias Completion = (CLLocationCoordinate2D, CLPlacemark) -> Void
    
    public var completion: Completion?
    
    private lazy var locationManager: CLLocationManager = {
        $0.delegate = self
        $0.distanceFilter = 5
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return $0
    }(CLLocationManager())
    
}

public extension HGLocation {
    
    func startLocation() {
        if CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlertToEnableLocationServices()
        }
    }
    
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func showAlertToEnableLocationServices() {
        let alert = UIAlertController(title: "No Authorization", message: "[Location service] is not enabled. Please manually enable the location system Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        DispatchQueue.main.async {
            UIWindow.HG_KeyVC()?.present(alert, animated: true)
        }
    }
    
}

extension HGLocation: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("用户未授权")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("访问受限")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            if CLLocationManager.locationServicesEnabled() {
                print("定位服务开启，被拒绝")
            }
            else {
                print("定位服务关闭，不可用")
            }
        case .authorizedAlways:
            print("获得前后台授权")
        case .authorizedWhenInUse:
            print("获得前台授权")
        @unknown default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("定位失败，请检查手机网络以及定位")
            return
        }
        if location.horizontalAccuracy < 0 {
            print("定位失败，请检查手机网络以及定位")
            return
        }
        locationManager.stopUpdatingLocation()
        // 反地理编码
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard error == nil,
                  let placemark = placemarks?.first else {
                print("反地理编码失败")
                return
            }
            if self?.completion != nil {
                self?.completion?(location.coordinate, placemark)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败，请检查手机网络以及定位")
    }
    
}

extension UIWindow {
    
    static func HG_KeyVC(_ base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navVC = base as? UINavigationController {
            return HG_KeyVC(navVC.visibleViewController)
        }
        if let tabVC = base as? UITabBarController,
           let selectedVC = tabVC.selectedViewController {
            return HG_KeyVC(selectedVC)
        }
        if let presentedVC = base?.presentedViewController {
            return HG_KeyVC(presentedVC)
        }
        return base
    }
    
}
