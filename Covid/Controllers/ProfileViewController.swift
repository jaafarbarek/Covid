//
//  ProfileViewController.swift
//  Covid
//
//  Created by Jaafar Barek on 03/05/2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var firstShotLabel: UILabel!
    @IBOutlet weak var secondShotLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tests = [TestModel]()
    var vaccine: Vaccine? {
        didSet {
            if let vacc = self.vaccine {
                firstShotLabel.text = "\(vacc.shot1 ?? "") in \(vacc.date1 ?? "")"
                secondShotLabel.text = "\(vacc.shot2 ?? "") in \(vacc.date2 ?? "")"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.allowsSelection = false
        
        getVaccineRequest()
        getTestsRequest()
    }
    
    @IBAction func onLogoutTap(_ sender: UIButton) {
        UserDefaults.standard.setValue(nil, forKey: "token")
        UserDefaults.standard.setValue(nil, forKey: "isActive")
        UserDefaults.standard.setValue(nil, forKey: "activationDate")
        UserDefaults.standard.setValue(nil, forKey: "location")
        Constants.transitionToLoginScreen()
    }
    
    func getVaccineRequest() {
        guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
            return
        }

        var request = URLRequest(url: URL(string: "\(Constants.mainURL)user/test")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [:], options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response)
            do {
                let decoder = JSONDecoder()

                do {
                    let vaccine = try decoder.decode(Vaccine.self, from: data!)
                    print(vaccine)
                    
                    DispatchQueue.main.async {
                        self.vaccine = vaccine
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            } catch {
                print("error")
            }
        })

        task.resume()
    }
    
    func getTestsRequest() {
        guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
            return
        }

        var request = URLRequest(url: URL(string: "\(Constants.mainURL)user/test")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [:], options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response)
            do {
                let decoder = JSONDecoder()

                do {
                    let testsList = try decoder.decode([TestModel].self, from: data!)
                    print(testsList)
                    
                    DispatchQueue.main.async {
                        self.tests = testsList
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            } catch {
                print("error")
            }
        })

        task.resume()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.setup(test: tests[indexPath.row])
        return cell
    }
    
    
}


extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}
