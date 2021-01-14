//
//  customCollectionViewLayout.swift
//  SwiftExercise
//
//  Created by hiro on 2021/1/9.
//

import UIKit

class ShortVideoCollectionViewLayout: UICollectionViewFlowLayout {
    var attributesArray: [UICollectionViewLayoutAttributes] = []
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    func setLayoutAttributesForItem(at indexPath: IndexPath, size: CGSize) {
        // 下拉加载增量更新，提高性能
        if indexPath.row == attributesArray.count {
            let att = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            if indexPath.row == 0 {
                att.frame.origin.y = 0
                att.frame.origin.x = self.sectionInset.left
            } else if indexPath.row == 1 {
                att.frame.origin.y = 0
                att.frame.origin.x = attributesArray[0].frame.origin.x + size.width + self.minimumInteritemSpacing
            } else {
                let upsideAtt = attributesArray[indexPath.row - 2]
                att.frame.origin.y = upsideAtt.frame.origin.y + upsideAtt.frame.height + self.minimumLineSpacing
                att.frame.origin.x = upsideAtt.frame.origin.x
            }
            att.frame.size = size
            attributesArray.append(att)
        }
        
    }
    
    // 上拉刷新需要清空原有的attribute，下拉加载不需要调用
    func refreshLayoutAttributes() {
        attributesArray.removeAll()
    }
}
