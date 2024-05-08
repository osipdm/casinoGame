import UIKit
import AVFoundation
class Model {
    
    fileprivate static let modelInstance = Model()
    
    fileprivate init() {}
    
    static var instance : Model{
        get {
            return modelInstance
        }
    }
    
    var player : AVAudioPlayer?
    
    // update user score
    func updateScore(label : UILabel,cash amount : Int){
        label.text = "\(Int(amount))$"
        UserDefaults.standard.set(amount, forKey: Constant.user_cash)
    }
    
    // get last saved score
    func getScore() -> Int{
        let cash = UserDefaults.standard.integer(forKey: Constant.user_cash)
        return cash <= 0 ? 300 : cash
    }
    
    // check if it's first time playing
    func isFirstTime() -> Bool{
        let saveExist = UserDefaults.standard.bool(forKey: Constant.is_save_exist)
        if !saveExist{
            UserDefaults.standard.set(true, forKey: Constant.is_save_exist)
            return true
        }
        return false
    }
    
    // play sound
    func play(sound name : String){
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else{
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
    
    func saveDeviseId(id: String) {
        UserDefaults.standard.set(id, forKey: Constant.saveDeviceId)
    }
    
    var getBonus: Bool {
        get {
            return UserDefaults.standard.value(forKey: Constant.getBonus) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.getBonus)
        }
    }
    
    func getDeviseId() -> String {
        return (UserDefaults.standard.value(forKey: Constant.saveDeviceId) as? String ?? "" )
    }
    

    func clearDeviseId() {
        UserDefaults.standard.removeObject(forKey: Constant.saveDeviceId)
    }
    
    var getHighScore: Int {
        get {
            return UserDefaults.standard.value(forKey: Constant.saveHighScore) as? Int ?? 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.saveHighScore)
        }
    }
}

