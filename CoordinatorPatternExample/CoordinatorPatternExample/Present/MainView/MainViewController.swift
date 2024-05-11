//
//  MainViewController.swift
//  CoordinatorPatternExample
//
//  Created by 이중엽 on 5/11/24.
//

import UIKit

class MainViewController: UIViewController {

    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 55))
    
    var buttonClickedClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        view.addSubview(button)
        
        button.center = view.center
        button.setTitle("종료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        buttonClickedClosure?()
    }
}

