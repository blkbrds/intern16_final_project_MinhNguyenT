//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    /** Get notified when UICollectionView has finished asking for data
     http://gg.gg/a5u8h
     */
    func reloadData(moveTop: Bool, completion: (() -> Void)? = nil) {
        if moveTop {
            setContentOffset(.zero, animated: false)
        }

        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
            self?.layoutIfNeeded()
        }

        DispatchQueue.main.async {
            completion?()
        }
    }

    func reloadItem(at indexPath: IndexPath) {
        reloadItems(at: [indexPath])
    }

    override func reloadItems(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths where indexPathsForVisibleItems.contains(indexPath) {
            super.reloadItems(at: [indexPath])
        }
    }

    func reloadItems(inSection section: Int, moveTop: Bool) {
        if moveTop {
            setContentOffset(CGPoint(x: contentOffset.x, y: 0), animated: false)
        }
        reloadItems(at: (0..<numberOfItems(inSection: section)).map {
            IndexPath(item: $0, section: section)
        })
    }
}
