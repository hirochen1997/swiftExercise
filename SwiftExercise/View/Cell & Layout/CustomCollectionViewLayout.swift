//
//  customCollectionViewLayout.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/9.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElements(in: rect) ?? []
        
        //第一行贴近顶部
        array[0].frame.origin.y = 0
        array[1].frame.origin.y = 0
        
        for i in 2..<array.count {
            // 每一个cell与它正上方相邻的cell固定间隔
            array[i].frame.origin.y = array[i - 2].frame.origin.y + array[i - 2].frame.height + self.minimumLineSpacing
            
        }
        
        return array
    }
    
}
