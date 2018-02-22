//
//  ScreenViewController.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import UIKit

class ScreenViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    let screenVcCellIdentifier = "ScreenVcCell"
    override func viewWillLayoutSubviews() {
        profileImageView.setRounded()
    }
    @IBAction func backActionBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


extension ScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: screenVcCellIdentifier, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width * 0.30
        let height = (width * 4) / 3
        let size = CGSize.init(width: width, height: height)
        return size
    }
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
}
