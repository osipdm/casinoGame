import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startWebView(url: url)
    }
    
    private func startWebView(url: URL) {
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        webView.loadRequest(NSURLRequest(url: url) as URLRequest)
    }
}
