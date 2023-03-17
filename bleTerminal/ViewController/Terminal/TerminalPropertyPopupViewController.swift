//
//  TerminalPropertyPopupViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/16.
//

import UIKit

class TerminalPropertyPopupViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var vm: TerminalViewModel!
    var dto: [ServiceProperty]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableViewCell()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dto = vm.serviceProperty.value
        self.vm.getServiceOfPeer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initView() {
        self.popupView.layer.cornerRadius = 15
        self.popupView.layer.masksToBounds = true
        
        [ cancelButton ].forEach { button in
            button?.addTarget(self, action: #selector(buttonActionHandler), for: .touchUpInside)
        }
    }
    
    func initTableViewCell() {
        let cellNib = UINib(nibName: "TerminalPropertyTableViewCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    func setBinding() {
        self.vm.serviceProperty.bind { serviceProperty in
            self.dto = serviceProperty
            self.tableView.reloadData()
        }
    }
    
    @objc func buttonActionHandler(_ sender: UIButton) {
        switch sender {
        case cancelButton: self.dismiss(animated: false)
        default: return
        }
    }
}

extension TerminalPropertyPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dto = self.dto else { return .zero }
        return dto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dto = self.dto else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TerminalPropertyTableViewCell else { return UITableViewCell() }
        cell.set(serviceProperty: dto[indexPath.row])
        return cell
    }
}

extension TerminalPropertyPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            guard let dto = self.dto else { return }
            self.vm.changeSelectionProperty(property: dto[indexPath.row])
        }
    }
}
