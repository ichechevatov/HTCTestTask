
import UIKit

class ViewController: UIViewController {
    //MARK: - property
    @IBOutlet weak var tableView: UITableView!
    private let dataStore = StudentDataStore.shared
    
    //MARK: - lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Список студентов"
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - action method
    @IBAction func addButtonAction(_ sender: Any) {
        let detailVC = getDetailViewController()
        detailVC.configure(forData: nil, state: .create, index: nil)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func getDetailViewController() -> DetailViewController {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        var detailVC: DetailViewController
        if #available(iOS 13.0, *) {
             detailVC = mainStoryboard.instantiateViewController(identifier: "DetailSBID") as! DetailViewController
        } else {
            let detaiStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        detailVC = detaiStoryboard.instantiateInitialViewController() as! DetailViewController
        
        }
        
        return detailVC
    }
}

//MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = getDetailViewController()
        let data = dataStore.getStudent(forIndex: indexPath.row)
        detailVC.configure(forData: data, state: .edit, index: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            dataStore.deleteStudent(index: indexPath.row)
            tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.getCountStudents()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataStore.getStudent(forIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentTableViewCell
        cell.configure(data: data)
        return  cell
    }
}
