//
//  HomeTVViewController.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/13.
//

import UIKit

class HomeTVViewController: UIViewController {
    override func viewDidLoad() {
        print("tvController load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("tvController appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("tvController disappear")
    }
}
