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
    var dto: [Peer] = []
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        vm.stopScan()
    }
    
    func initView() {
        self.titleView.initView(from: self.nameString)
        
        self.titleView.onDidTapScanButton = { [weak self] in
            guard let self = self else { return }
            self.vm.startScan()
        }
        
        self.titleView.onDidTapStopButton = { [weak self] in
            guard let self = self else { return }
            self.vm.stopScan()
        }
    }
    
    func initTableViewCell() {
        let cellNib = UINib(nibName: "BleListTableViewCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    func setBinding() {
        self.vm.scanState.bind { [weak self] state in
            guard let self = self else { return }
            self.titleView.changeScanState(to: state)
        }
        
        self.vm.peers.bind { [weak self] peers in
            guard let self = self else { return }
            self.dto = peers
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
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TerminalViewController") as? TerminalViewController else { return }
        
        let peer = self.dto[indexPath.row]
        vc.vm = TerminalViewModel(peer: peer)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
