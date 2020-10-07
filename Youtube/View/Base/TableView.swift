//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit
import MVVM

class TableView: UITableView, MVVM.View {
    /** Get notified when UITableView has finished asking for data
    http://gg.gg/a5u8h
     */
    func reloadData(moveTop: Bool, completion: (() -> Void)? = nil) {
        if moveTop {
            setContentOffset(CGPoint(x: contentOffset.x, y: 0), animated: false)
            layoutIfNeeded()
        }

        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.reloadData()
            this.layoutIfNeeded()
        }

        DispatchQueue.main.async {
            completion?()
        }
    }

    func reloadRow(at indexPath: IndexPath, animation: RowAnimation = .none) {
        reloadRows(at: [indexPath], with: animation)
    }

    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        guard let visibleRows = indexPathsForVisibleRows else { return }
        for indexPath in indexPaths where visibleRows.contains(indexPath) {
            super.reloadRows(at: [indexPath], with: animation)
        }
    }
}

extension IndexPath {
    static var zero: IndexPath = IndexPath(item: 0, section: 0)
}
