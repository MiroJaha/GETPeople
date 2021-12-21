//
//  ViewController.swift
//  GETPeople
//
//  Created by admin on 21/12/2021.
//

import UIKit

class PeopleViewController: UIViewController {
    
    var pageNumber = 1
    var peopleList = [String]()
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var pageNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check()
        gettingDataFromAPI()
        mainTableView.dataSource = self
    }
    
    func gettingDataFromAPI() {
        peopleList.removeAll()
        // specify the url that we will be sending the GET Request to
        let url = URL(string: "https://swapi.dev/api/people/?page=\(pageNumber)&format=json")
        // create a URLSession to handle the request taskscopy
        let session = URLSession.shared
        // create a "data task" to make the request and run the completion handler
        let task = session.dataTask(with: url!, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["results"] {
                        // coercing the results object as an NSArray and then storing that in resultsArray
                        let resultsArray = results as! NSArray
                        // now we can run NSArray methods like count and firstObject
                        for result in resultsArray {
                            if let data = result as? NSDictionary {
                                if let result = data["name"] {
                                    let name = result as! String
                                    self.peopleList.append(name)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.mainTableView.reloadData()
                        }
                    }
                }
            } catch {
                print(error)
            }
        })
        // execute the task and wait for the response before
        // running the completion handler. This is async!
        task.resume()
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        pageNumber += 1
        pageNumberLabel.text = "Page: \(pageNumber)/9"
        check()
        gettingDataFromAPI()
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        pageNumber -= 1
        pageNumberLabel.text = "Page: \(pageNumber)/9"
        check()
        gettingDataFromAPI()
    }
    func check() {
        if pageNumber == 9 {
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
        }
        if pageNumber == 1 {
            previousButton.isEnabled = false
        }else {
            previousButton.isEnabled = true
        }
    }
    
}

extension PeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = peopleList[indexPath.row]
        return cell
    }
    
    
}
