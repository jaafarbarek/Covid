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
    var familyMembers = [FamilyMember]()
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getVaccineRequest()
        getFamilyRequest()
        self.getTestsRequest()
    }
    
    @IBAction func onLogoutTap(_ sender: UIButton) {
        UserDefaults.standard.setValue(nil, forKey: "token")
        UserDefaults.standard.setValue(nil, forKey: "isActive")
        UserDefaults.standard.setValue(nil, forKey: "activationDate")
        UserDefaults.standard.setValue(nil, forKey: "location")
        Constants.transitionToLoginScreen()
    }
    
    func getFamilyRequest() {
        guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
            return
        }

        var request = URLRequest(url: URL(string: "\(Constants.mainURL)user/family")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response)
            
            do {
                let decoder = JSONDecoder()

                guard let data = data else {
                    return
                }
                
                do {
                    let members = try decoder.decode([FamilyMember].self, from: data)
                    print(members)
                    
                    DispatchQueue.main.async {
                        self.familyMembers = members
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
    
    func getVaccineRequest() {
        guard let token = UserDefaults.standard.value(forKey: "token") as? String else {
            return
        }

        var request = URLRequest(url: URL(string: "\(Constants.mainURL)user/vaccines")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response)
            do {
                let decoder = JSONDecoder()

                guard let data = data else {
                    return
                }
                
                do {
                    let vaccine = try decoder.decode(Vaccine.self, from: data)
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

        var request = URLRequest(url: URL(string: "\(Constants.mainURL)user/tests")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response)
            do {
                guard let data = data else {
                    return
                }
                
                let decoder = JSONDecoder()

                do {
                    let testsList = try decoder.decode([TestModel].self, from: data)
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
        
        switch section {
        case 0:
            return tests.count
        case 1:
            return familyMembers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        if indexPath.section == 0 {
            cell.setup(test: tests[indexPath.row])
        } else {
            let member = familyMembers[indexPath.row]
            cell.setup(test: TestModel(date: member.date, location: "", name: member.relation, status: member.status))
        }
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "My Tests"
        case 1:
            return "Family Tests"
        default:
            return ""
        }
    }
}


extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}
