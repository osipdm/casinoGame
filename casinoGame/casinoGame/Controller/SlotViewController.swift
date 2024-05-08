import UIKit

class SlotViewController: UIViewController {
    
    @IBOutlet weak var spin: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cashToRiskLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var slotView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var highScoreLabel: UILabel!
    
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
    
    let images = [#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "6")]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
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
        view.backgroundColor = UIColor(red: 179/255, green: 45/255, blue: 45/255, alpha: 1)
        stepper.layer.cornerRadius = stepper.frame.height / 2
        stepper.backgroundColor = .white
        stepper.tintColor = .red
        pickerView.delegate = self
        pickerView.layer.cornerRadius = 10
        pickerView.layer.borderColor = UIColor.orange.cgColor
        pickerView.layer.borderWidth = 5
        spin.layer.cornerRadius = spin.frame.height / 2
        spin.backgroundColor = .white
        spin.layer.borderColor = UIColor.orange.cgColor
        spin.layer.borderWidth = 5
        
        slotView.layer.borderColor = UIColor.orange.cgColor
        slotView.layer.borderWidth = 5
        messageView.layer.cornerRadius = messageView.frame.height / 2
    }
    
    func startGame(){
        self.cashLabel.text = "\(Model.instance.getScore())$"
        self.highScoreLabel.text = "\(Model.instance.getHighScore)$"
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
                self.stepper.maximumValue = Double(self.currentCash)
            }
        }
    }
    
    func roll(){
        var delay : TimeInterval = 0
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
            let random = Int.random(in: 2...4)
            let alert = UIAlertController(title: "BIG WIN", message: "Ваш выйгрыш \((100 + cashToRisk) * random)$", preferredStyle: .alert)
            let next = UIAlertAction(title: "Продолжить", style: .default) { [weak self] _ in
                guard let self = self else {return}
                Model.instance.getHighScore = (100 + self.cashToRisk) * random
                self.highScoreLabel.text = "\(Model.instance.getHighScore)$"
            }
            alert.addAction(next)
            present(alert, animated: true)
            Model.instance.updateScore(label: cashLabel,cash: (currentCash + (100 + cashToRisk) * random))
        } else {
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
        spin.isUserInteractionEnabled = false
        Model.instance.play(sound: Constant.spin_sound)
        roll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkWin()
            self.spin.isUserInteractionEnabled = true
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 223/255.0, green: 118/255.0, blue: 70/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 44/255.0, green: 42/255.0, blue: 90/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}


//MARK: - UIPickerView
extension SlotViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
  
        let index = row % images.count
        let image = images[index]
        return UIImageView(image: ResizeImage.resize(image: image, targetSize: CGSize(width: 80, height: 80)))
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return images[component].size.height + 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 88
    }
}
