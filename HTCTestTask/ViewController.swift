
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataStore = StudentDataStore.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Список студентов"
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    @IBAction func addButtonAction(_ sender: Any) {
        let detailVC = getDetalViewController()
        detailVC.configure(forData: nil, state: .creat,index: nil)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func getDetalViewController() -> DetailViewController{
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC = mainStoryboard.instantiateViewController(identifier: "DetailSBID")
        return detailVC as! DetailViewController
    }
    

}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = getDetalViewController()
        let data = dataStore.getStudent(forIndex: indexPath.row)
        detailVC.configure(forData: data, state: .edit, index: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            dataStore.deletStudent(index: indexPath.row)
             tableView.reloadData()
        }
    }
    
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.getCountStudent()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataStore.getStudent(forIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentTableViewCell
        cell.configure(data: data)
        
        return  cell
    }
}
