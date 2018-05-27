
import UIKit
import SDWebImage

class ViewController: UIViewController {

    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    var itemList: [UserItems] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAddSubViews()
        configureLayout()
        configureSubViews()
    }

    func configureAddSubViews() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    func configureLayout() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func configureSubViews() {
        navigationItem.title = "とっぷ"
        
        searchBar.delegate = self
        searchBar.placeholder = "探したいアカウント名を入力してください"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    func request(urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                guard let data = data else { return }
                let gitUserResponse = try! JSONDecoder().decode(GitUserResponse.self, from: data)
                self.itemList = gitUserResponse.items
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            task.resume()
        }
    }
    
    func createReqestUrl(searchWord: String) -> String {
        let url = "https://api.github.com/search/users?"
        guard let reqParam = searchWord.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return ""
        }
        return url + "q=" + reqParam
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text else { return }
        let urlString = createReqestUrl(searchWord: inputText)
        request(urlString: urlString)
        view.endEditing(true)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let WebVC = WebViewController(userURL: itemList[indexPath.row].html_url)
        navigationController?.pushViewController(WebVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        view.endEditing(true)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        if itemList.count > 0 {
            let item = itemList[Int(indexPath.row)]
            cell.userName.text = item.login
            cell.userType.text = item.type
            cell.url = item.html_url
            cell.userImage.sd_setImage(with: URL(string: item.avatar_url))
        }
        
        return cell
    }
}
