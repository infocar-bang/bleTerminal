//
//  MainViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/08.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var titleView: TitleView!
    @IBOutlet weak var bleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initTableViewCell()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initView()
        setBinding()
    }
    
    func initView() {
        self.titleView.initView(from: self.nameString)
        self.titleView.setButtonAction {
            // BLE scan start
        } stopButtonAction: {
            // BLE scan stop
        } menuButtonAction: {
            // show menu
        }

    }
    
    func initTableViewCell() {
        let cellNib = UINib(nibName: "BleListTableViewCell", bundle: Bundle(for: self.classForCoder))
        self.bleTableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    func setBinding() {
        
    }
}

// MARK:- UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BleListTableViewCell else {
            return UITableViewCell()
        }
        cell.set()
        
        return cell
    }
    
    
}

// MARK:- UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // push TerminalView
    }
}
