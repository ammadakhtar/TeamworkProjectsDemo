//
//  ActivityViewController.swift
//  TestingTeam
//
//  Created by Ammad on 23/07/2017.
//  Copyright © 2017 Ammad. All rights reserved.
//

import UIKit
import Alamofire
import XLActionController
import BRYXBanner

typealias DownloadComplete = () -> ()

class ActivityViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tableView : UITableView!
    var activity : [ActivityArray]? = []
    var refresher : UIRefreshControl!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refresher.addTarget(self, action: #selector(ActivityViewController.pullrefrsher), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        fetchActivity(){}
    }
    
    
    
    func fetchActivity(completed: @escaping DownloadComplete) {
        activity?.removeAll()
        if let apikey = defaults.object(forKey: "userapi") as? String {
            let user = apikey
            let password = "password"
            
            Alamofire.request("https://ammad.teamwork.com/latestActivity.json/\(user)/\(password)")
                .authenticate(user: user, password: password)
                .responseJSON { response in
                    let result = response
                    if let data = result.value as? Dictionary <String , AnyObject> {
                        if let result = data["activity"] as? [Dictionary <String, AnyObject>] {
                            for result in result {
                                let activity = ActivityArray()
                                if let description = result["description"] as? String {
                                    activity.desc = description
                                }
                                if let projname = result["project-name"] as? String? {
                                    activity.proj_name = projname
                                }
                                if let username = result["fromusername"] as? String {
                                    activity.username = username
                                }
                                if let date = result["datetime"] as? String {
                                    let isoformatter = ISO8601DateFormatter()
                                    let date = isoformatter.date(from: date)
                                    let newformatter = DateFormatter()
                                    newformatter.dateFormat = "E h:mm a"
                                    let newdate = newformatter.string(from: date!)
                                    activity.date = newdate
                                }
                                self.activity?.append(activity)
                            }
                            self.tableView.reloadData()
                            self.refresher.endRefreshing()
                        }
                    }
                    completed()
            }
        }
        
        
    }
    
    func pullrefrsher () {
        self.fetchActivity() {
            defer { let banner = Banner(title: "You are upto date!", image: UIImage(named: "check"), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                banner.dismissesOnTap = true
                banner.show(duration: 0.2)
            }
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityCell
        cell.projDescription.text = self.activity?[indexPath.item].desc
        cell.projectName.text = self.activity?[indexPath.item].proj_name
        cell.projOwner.titleLabel?.text = "AA"
        cell.addedBy.text = "added By \((self.activity?[indexPath.item].username)!) \((self.activity?[indexPath.item].date)!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activity?.count ?? 0
    }
    
    @IBAction func ActionSheetPressed(_ sender: Any) {
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Task", image: UIImage(named: "tick")!), style: .default, handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Message", image: UIImage(named: "message-1")!), style: .default, handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Event", image: UIImage(named: "event")!), style: .default, handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Milestone", image: UIImage(named: "milestone")!), style: .default, handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Time Log", image: UIImage(named: "timelog")!), style: .default, handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "NoteBook", image: UIImage(named: "notebook")!), style: .default, handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "File", image: UIImage(named: "file")!), style: .cancel, handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }
}
