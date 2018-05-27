
import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView = WKWebView()
    var userUrl: String = ""
    
    init(userURL: String) {
        super.init(nibName: nil, bundle: nil)
        self.userUrl = userURL
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "うぇぶぺーじ"
        configureAddSubViews()
        configureLayout()
        loadWebView()
    }

    func configureAddSubViews() {
        view.addSubview(webView)
    }
    
    func configureLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func loadWebView() {
        if let url = URL(string: userUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
