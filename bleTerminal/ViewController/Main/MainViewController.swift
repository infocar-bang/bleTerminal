//
//  MainViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/08.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var titleView: TitleView!
    @IBOutlet weak var tableView: UITableView!
    
    let vm = MainViewModel()
    var dto: [PeripheralDevice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
        initTableViewCell()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vm.startScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initView() {
        guard let navigationControllerInstance = self.navigationController else { return }
        self.titleView.initView(from: self.nameString, navigationController: navigationControllerInstance)
        self.titleView.setButtonAction(scanButtonAction: {
            
        }, stopButtonAction: { [weak self] in
            guard let self = self else { return }
            self.vm.stopScan()
        })
    }
    
    func initTableViewCell() {
        let cellNib = UINib(nibName: "BleListTableViewCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    func setBinding() {
        vm.listener = { [weak self] peers in
            guard let self = self else { return }
            self.dto = peers.compactMap({ $0 })
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BleListTableViewCell else {
            return UITableViewCell()
        }
        cell.set(peer: dto[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // push TerminalView
        guard let terminalViewController = self.storyboard?.instantiateViewController(withIdentifier: "TerminalViewController") else { return }
        self.navigationController?.pushViewController(terminalViewController, animated: true)
    }
}
