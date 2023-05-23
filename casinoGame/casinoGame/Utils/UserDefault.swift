
import UIKit

class UserDefault {
    
    static let shared = UserDefault()
    
    enum Keys: String {
        case deviseId
        case isFirstLogin
    }
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    func saveDeviseId(id: String) {
        defaults.set(id, forKey: Keys.deviseId.rawValue)
    }
    
    var getBonus: Bool {
        get {
            return defaults.value(forKey: Keys.isFirstLogin.rawValue) as? Bool ?? true
        }
        set {
            defaults.set(newValue, forKey: Keys.isFirstLogin.rawValue)
        }
    }
    
    func getDeviseId() -> String {
        return (defaults.value(forKey: Keys.deviseId.rawValue) as? String ?? "" )
    }
    

    func clearDeviseId() {
        defaults.removeObject(forKey: Keys.deviseId.rawValue)
    }
}
