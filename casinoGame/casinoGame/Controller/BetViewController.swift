import UIKit
import WebKit
import AVFoundation
import FirebaseRemoteConfig

class BetViewController: UIViewController {
    
    
    //MARK: - Propirties
    
//    @IBOutlet weak var spin: UIButton!
//    @IBOutlet weak var pickerView: UIPickerView!
//    @IBOutlet weak var cashImageView: UIImageView!
//    @IBOutlet weak var cashToRiskLabel: UILabel!
//    @IBOutlet weak var stepper: UIStepper!
//    @IBOutlet weak var cashLabel: UILabel!
//    @IBOutlet weak var backView: UIImageView!
//    @IBOutlet weak var slotView: UIView!
//    @IBOutlet weak var messageView: UIView!
    
//    lazy var webView: UIWebView = {
//         let view = UIWebView()
//         view.translatesAutoresizingMaskIntoConstraints = false
//         return view
//     }()
    
//    var cashToRisk : Int = 10{
//        didSet{
//            cashToRiskLabel.text = "\(currentCash)$"
//        }
//    }
//
//    var currentCash : Int{
//        guard let cash = cashLabel.text, !(cashLabel.text?.isEmpty)! else {
//            return 0
//        }
//        return Int(cash.replacingOccurrences(of: "$", with: ""))!
//    }
//
//    var activityView: UIActivityIndicatorView?
//    var remoteConfig = RemoteConfig.remoteConfig()
//    let images = [#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "6")]
    
    //MARK: - viewDidLoad
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 0
//        remoteConfig.configSettings = settings
//        self.setupWebView()
//        self.showActivityIndicator()
//        remoteConfig.fetchAndActivate { status, error in
//            if error != nil {
//                print(error?.localizedDescription ?? "")
//                self.backView.isHidden = true
//                self.startGameScene()
//            } else {
//                if status != .error {
//                    if self.remoteConfig["notIsHidden"].boolValue {
//                        if let urlString = self.remoteConfig["urlString"].stringValue {
//                            self.hideActivityIndicator()
//                            self.checkIP(urlString: urlString)
//                        } else {
//                            self.hideActivityIndicator()
//                            self.backView.isHidden = true
//                            self.startGameScene()
//                        }
//                    } else {
//                        print("ID -> \(Model.instance.getDeviseId())")
//                        if Model.instance.getDeviseId() != "" {
//                            if let urlString = self.remoteConfig["urlString"].stringValue {
//                                self.hideActivityIndicator()
//                                self.checkIP(urlString: urlString)
//                            } else {
//                                self.hideActivityIndicator()
//                                self.backView.isHidden = true
//                                self.startGameScene()
//                            }
//                        } else {
//                            self.hideActivityIndicator()
//                            self.backView.isHidden = true
//                            self.startGameScene()
//                        }
//                    }
//                } else {
//                    self.hideActivityIndicator()
//                    self.backView.isHidden = true
//                    self.startGameScene()
//                }
//            }
//        }
//    }
    
    
    //MARK: -  @IBAction actions
    
//    @IBAction func stepperAction(_ sender: UIStepper) {
//        stepper.maximumValue = Double(currentCash)
//        let amount = Int(sender.value)
//        if currentCash >= amount{
//            cashToRisk = amount
//            cashToRiskLabel.text = "\(amount)$"
//        }
//    }
//
//    @IBAction func spinButton(_ sender: Any) {
//        spinAction()
//        if Model.instance.getBonus {
//            Model.instance.getBonus = false
//        }
//    }
    
//    //MARK: -  setup method
//    private func setupUI() {
//        view.backgroundColor = UIColor(red: 179/255, green: 45/255, blue: 45/255, alpha: 1)
//        stepper.layer.cornerRadius = stepper.frame.height / 2
//        stepper.backgroundColor = .white
//        stepper.tintColor = .red
//        pickerView.delegate = self
//        pickerView.layer.cornerRadius = 10
//        pickerView.layer.borderColor = UIColor.red.cgColor
//        pickerView.layer.borderWidth = 5
//        spin.layer.cornerRadius = spin.frame.height / 2
//        spin.backgroundColor = .white
//        spin.layer.borderColor = UIColor.orange.cgColor
//        spin.layer.borderWidth = 5
//        
//        slotView.layer.borderColor = UIColor.orange.cgColor
//        slotView.layer.borderWidth = 5
//        messageView.layer.cornerRadius = messageView.frame.height / 2
//    }
    
//    private func startWebView(url: URL) {
//        webView.scrollView.showsHorizontalScrollIndicator = false
//        webView.scrollView.showsVerticalScrollIndicator = false
//        webView.scrollView.bounces = false
//        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        webView.loadRequest(NSURLRequest(url: url) as URLRequest)
//    }
    
//    private func startGameScene() {
//        self.startGame()
//        self.setupUI()
//    }
//    
//    func startGame(){
////        Model.instance.updateScore(label: self.cashLabel, cash: 300)
//        self.cashLabel.text = "\(Model.instance.getScore())$"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
//            guard let self = self else {return}
//            if Model.instance.getBonus {
//                let alert = UIAlertController(title: "БОНУС", message: "+200$ на первый депозит", preferredStyle: .alert)
//                alert.addAction( UIAlertAction(title: "Получить", style: .default, handler: { (_) in
//                    Model.instance.updateScore(label: self.cashLabel ,cash: 500)
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                self.cashLabel.text = "\(Model.instance.getScore())$"
////                if Model.instance.isFirstTime(){ // check if it's first time playing
////                    Model.instance.updateScore(label: self.cashLabel, cash: 300)
////                } else { // get last saved score
////                    self.cashLabel.text = "\(Model.instance.getScore())$"
////                } // set max bet
//                self.stepper.maximumValue = Double(self.currentCash)
//            }
//        }
//    }
//    
//    func roll(){ // roll pickerview
//        var delay : TimeInterval = 0
//        // iterate over each component, set random img
//        for i in 0..<pickerView.numberOfComponents{
//            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
//                self.randomSelectRow(in: i)
//            })
//            delay += 0.30
//        }
//    }
//    
//    func randomSelectRow(in comp : Int){
//        let r = Int(arc4random_uniform(UInt32(8 * images.count))) + images.count
//        pickerView.selectRow(r, inComponent: comp, animated: true)
//        
//    }
//    
//    func checkWin(){
//        
//        var lastRow = -1
//        var counter = 0
//        
//        for i in 0..<pickerView.numberOfComponents{
//            let row : Int = pickerView.selectedRow(inComponent: i) % images.count // selected img idx
//            if lastRow == row{ // two equals indexes
//                counter += 1
//            } else {
//                lastRow = row
//                counter = 1
//            }
//        }
//        
//        if counter == 3 { // winning
//            Model.instance.play(sound: Constant.win_sound)
//            stepper.maximumValue = Double(currentCash)
//            let random = Int.random(in: 2...4)
//            let alert = UIAlertController(title: "BIG WIN", message: "Ваш выйгрыш \((100 + cashToRisk) * random)$", preferredStyle: .alert)
//            let next = UIAlertAction(title: "Продолжить", style: .default)
//            alert.addAction(next)
//            present(alert, animated: true)
////            Model.instance.updateScore(label: cashLabel,cash: (currentCash + 200) + (cashToRisk * 2))
//            Model.instance.updateScore(label: cashLabel,cash: (currentCash + (100 + cashToRisk) * random))
//        } else { // losing
//            Model.instance.updateScore(label: cashLabel,cash: (currentCash - cashToRisk))
//        }
//        
//        // if cash is over
//        if currentCash <= 0 {
//            gameOver()
//        } else{  // update bet stepper
//            if Int(stepper.value) > currentCash {
//                stepper.maximumValue = Double(currentCash)
//                cashToRisk = currentCash
//                stepper.value = Double(currentCash)
//            }
//        }
//    }
//    
//    func gameOver(){ // when game is over, show alert
//        let alert = UIAlertController(title: "Игра окончена", message: "У вас на счете \(currentCash)$ \nИграть снова?", preferredStyle: .alert)
//        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { (_) in
//            self.startGame()
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func spinAction(){
//        spin.isUserInteractionEnabled = false // disable clicking
//        Model.instance.play(sound: Constant.spin_sound)
//        roll()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.checkWin()
//            self.spin.isUserInteractionEnabled = true
//        }
//    }
    
//    func checkIP(urlString: String) {
//            getIpLocation { code, error in
//                if error != nil {
//                    print("ERROR = \(error?.localizedDescription ?? "")")
//                    self.startGameScene()
//                } else {
//                    switch code {
//                    case "BYs":
//                        guard let url = URL(string: urlString) else { return }
//                        let uid = UUID().uuidString
//                        Model.instance.saveDeviseId(id: uid)
//                        self.backView.image = UIImage()
//                        self.backView.backgroundColor = .white
//                        self.webView.isHidden = false
//                        self.startWebView(url: url)
//                    default:
//                        self.backView.isHidden = true
//                        self.startGameScene()
//                    }
//                }
//            }
//        }
    
//    func getIpLocation(completion: @escaping(String?, Error?) -> Void) {
//        let url = URL(string: "http://ip-api.com/json")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
//            DispatchQueue.main.async {
//                if let content = data {
//                    do {
//                        if let object = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as? NSDictionary {
//
//                            let countryCode = object["countryCode"] as? String
//                            print("COUNTRY CODE: \(countryCode)")
//                            completion(countryCode, error)
//                        } else {
//                            completion(nil, error)
//                        }
//                    } catch {
//                        completion(nil, error)
//                    }
//                } else {
//                    completion(nil, error)
//                }
//            }
//        }).resume()
//    }
    
//    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//
//        let widthRatio  = targetSize.width  / image.size.width
//        let heightRatio = targetSize.height / image.size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//        }
//
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage ?? UIImage()
//    }
}

//MARK: - UIPickerView
//extension BetViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return images.count * 10
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//  
//        let index = row % images.count
//        let image = images[index]
//        return UIImageView(image: resizeImage(image: image, targetSize: CGSize(width: 80, height: 80)))
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return images[component].size.height + 20
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 88
//    }
//    
//}


//MARK: - BetViewController
//extension BetViewController {
    
    //MARK: - setup Constraints
//
//    func setupWebView() {
//        view.addSubview(webView)
//        webView.isHidden = true
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
//        ])
//    }
//
//    //MARK: - Activity indicator method
//
//    func showActivityIndicator() {
//        if #available(iOS 13.0, *) {
//            activityView = UIActivityIndicatorView(style: .large)
//        }
//        activityView?.color = .black
//        activityView?.center = self.view.center
//        self.view.addSubview(activityView!)
//        activityView?.startAnimating()
//    }
//
//    func hideActivityIndicator(){
//        if (activityView != nil) {
//            activityView?.stopAnimating()
//            activityView?.hidesWhenStopped = true
//        }
//    }
//}
