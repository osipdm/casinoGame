import UIKit
import WebKit
import AVFoundation

class BetViewController: UIViewController {
    
    
    //MARK: - Propirties
    
    @IBOutlet weak var spin: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cashImageView: UIImageView!
    @IBOutlet weak var cashToRiskLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var cashLabel: UILabel!
    
    lazy var webView: UIWebView = {
         let view = UIWebView()
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    var cashToRisk : Int = 10{
        didSet{
            cashToRiskLabel.text = "\(currentCash)$"
        }
    }
    
    var currentCash : Int{
        guard let cash = cashLabel.text, !(cashLabel.text?.isEmpty)! else {
            return 0
        }
        return Int(cash.replacingOccurrences(of: "$", with: ""))!
    }
    
    var activityView: UIActivityIndicatorView?
   
    let images = [#imageLiteral(resourceName: "crown"), #imageLiteral(resourceName: "seven"), #imageLiteral(resourceName: "cherry"), #imageLiteral(resourceName: "lemon"), #imageLiteral(resourceName: "bar"), #imageLiteral(resourceName: "dimond")]

    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        setupUI()
    }
    
    
    //MARK: -  @IBAction actions
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        stepper.maximumValue = Double(currentCash)
        let amount = Int(sender.value)
        if currentCash >= amount{
            cashToRisk = amount
            cashToRiskLabel.text = "\(amount)$"
        }
    }
    
    @IBAction func spinButton(_ sender: Any) {
        spinAction()
        if Model.instance.getBonus {
            Model.instance.getBonus = false
        }
    }
    
    //MARK: -  setup method
    private func setupUI() {
        stepper.layer.cornerRadius = stepper.frame.height / 2
        pickerView.delegate = self
    }
    
    func startWebView(url: URL) {
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        webView.loadRequest(NSURLRequest(url: url) as URLRequest)
    }
    
    func startGame(){
        Model.instance.updateScore(label: self.cashLabel, cash: 300)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else {return}
            if Model.instance.getBonus {
                let alert = UIAlertController(title: "БОНУС", message: "+200$ на первый депозит", preferredStyle: .alert)
                alert.addAction( UIAlertAction(title: "Получить", style: .default, handler: { (_) in
                    Model.instance.updateScore(label: self.cashLabel ,cash: 500)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.cashLabel.text = "\(Model.instance.getScore())$"
//                if Model.instance.isFirstTime(){ // check if it's first time playing
//                    Model.instance.updateScore(label: self.cashLabel, cash: 300)
//                } else { // get last saved score
//                    self.cashLabel.text = "\(Model.instance.getScore())$"
//                } // set max bet
                self.stepper.maximumValue = Double(self.currentCash)
            }
        }
    }
    
    func roll(){ // roll pickerview
        var delay : TimeInterval = 0
        // iterate over each component, set random img
        for i in 0..<pickerView.numberOfComponents{
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.randomSelectRow(in: i)
            })
            delay += 0.30
        }
    }
    
    func randomSelectRow(in comp : Int){
        let r = Int(arc4random_uniform(UInt32(8 * images.count))) + images.count
        pickerView.selectRow(r, inComponent: comp, animated: true)
        
    }
    
    func checkWin(){
        
        var lastRow = -1
        var counter = 0
        
        for i in 0..<pickerView.numberOfComponents{
            let row : Int = pickerView.selectedRow(inComponent: i) % images.count // selected img idx
            if lastRow == row{ // two equals indexes
                counter += 1
            } else {
                lastRow = row
                counter = 1
            }
        }
        
        if counter == 3 { // winning
            Model.instance.play(sound: Constant.win_sound)
            stepper.maximumValue = Double(currentCash)
            let random = Int.random(in: 2...6)
            let alert = UIAlertController(title: "BIG WIN", message: "Ваш выйгрыш \((100 + cashToRisk) * random)$", preferredStyle: .alert)
            let next = UIAlertAction(title: "Продолжить", style: .default)
            alert.addAction(next)
            present(alert, animated: true)
            Model.instance.updateScore(label: cashLabel,cash: (currentCash + 200) + (cashToRisk * 2))
        } else { // losing
            Model.instance.updateScore(label: cashLabel,cash: (currentCash - cashToRisk))
        }
        
        // if cash is over
        if currentCash <= 0 {
            gameOver()
        } else{  // update bet stepper
            if Int(stepper.value) > currentCash {
                stepper.maximumValue = Double(currentCash)
                cashToRisk = currentCash
                stepper.value = Double(currentCash)
            }
        }
    }
    
    func gameOver(){ // when game is over, show alert
        let alert = UIAlertController(title: "Игра окончена", message: "У вас на счете \(currentCash)$ \nИграть снова?", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.startGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func spinAction(){
        spin.isUserInteractionEnabled = false // disable clicking
        Model.instance.play(sound: Constant.spin_sound)
        roll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkWin()
            self.spin.isUserInteractionEnabled = true
        }
        
    }

}

//MARK: - UIPickerView
extension BetViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % images.count
        return UIImageView(image: images[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return images[component].size.height + 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 45
    }
}


//MARK: - BetViewController
extension BetViewController {
    
    //MARK: - setup Constraints
    
    func setupWebView() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    //MARK: - Activity indicator method
    
    func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.color = .black
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil) {
            activityView?.stopAnimating()
            activityView?.hidesWhenStopped = true
        }
    }
}
