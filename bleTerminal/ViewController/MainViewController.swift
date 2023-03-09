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
        // 닙파일등록
        let bleListCell = UINib(nibName: "BleListTableViewCell", bundle: nil)
        self.bleTableView.register(bleListCell, forCellReuseIdentifier: "cell")
    }
    
    func setBinding() {
        
    }
}

// MARK:- UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

// MARK:- UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // push TerminalView
    }
}
