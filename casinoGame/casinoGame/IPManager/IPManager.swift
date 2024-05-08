import Foundation

class IPMagager {
    
    static func getIpLocation(completion: @escaping(String?, Error?) -> Void) {
        let url = URL(string: "http://ip-api.com/json")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let content = data {
                    do {
                        if let object = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as? NSDictionary {
                            
                            let countryCode = object["countryCode"] as? String
                            print("COUNTRY CODE: \(countryCode)")
                            completion(countryCode, error)
                        } else {
                            completion(nil, error)
                        }
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }).resume()
    }
}
