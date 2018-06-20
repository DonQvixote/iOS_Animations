//
//  LockScreenViewController.swift
//  Widgets
//
//  Created by 夏语诚 on 2018/6/19.
//  Copyright © 2018年 Banana. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTopConstraint: NSLayoutConstraint!
    
    @IBAction func presentSettings(_ send: Any? = nil) {
        // present the view controller
        settingsViewController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        present(settingsViewController, animated: true, completion: nil)
    }
    
    
    let blurView = UIVisualEffectView(effect: nil)
    
    var settingsViewController: SettingsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bringSubview(toFront: searchBar)
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0
        blurView.isUserInteractionEnabled = false
        view.insertSubview(blurView, belowSubview: searchBar)
        
        tableView.estimatedRowHeight = 130.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.transform = CGAffineTransform(scaleX: 0.67, y: 0.67)
        tableView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AnimatorFactory.scaleUp(view: tableView).startAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        blurView.frame = view.bounds
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func toggleBlur(_ blurred: Bool) {
        AnimatorFactory.fade(view: blurView, visible: blurred)
    }
}

extension LockScreenViewController: WidgetsOwnerProtocol { }

extension LockScreenViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Footer") as! FooterCell
            cell.didPressEdit = {[unowned self] in
                self.presentSettings()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WidgetCell
            cell.tableView = tableView
            cell.owner = self
            return cell
        }
    }
}

extension LockScreenViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        toggleBlur(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        toggleBlur(false)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.resignFirstResponder()
        }
    }
}
