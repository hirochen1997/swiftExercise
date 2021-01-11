//
//  HomeTVView.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/11.
//

import UIKit

class HomeTVView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let TVView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 2 * buttonHeight))
        TVView.backgroundColor = UIColor.purple
        self.addSubview(TVView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
