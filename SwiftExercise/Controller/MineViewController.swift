//
//  MineViewController.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/5.
//

import Foundation
import UIKit

class MineViewController: UIViewController{
    override func viewDidLoad() {
        let mineView = SEMineView(frame: CGRect(x: 0, y: buttonHeight, width: kScreenWidth, height: kScreenHeight-buttonHeight))
        self.view.addSubview(mineView)
    }
}
