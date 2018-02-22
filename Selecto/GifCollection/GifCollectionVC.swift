//
//  GifCollectionVC.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//
import UIKit

class GifCollectionViewController: UIViewController {
    @IBOutlet weak var gifCollectionView: UICollectionView!
    let gifCellIdentifier = "GifCell"
    @IBAction func backActionBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension GifCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gifCellIdentifier, for: indexPath) as! GifCollectionViewCell
        cell.gifImageView.loadGif(name: "giphy")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.gifCollectionView.frame.size.height * 0.31
        let width = self.gifCollectionView.frame.size.width * 0.31
        let size = CGSize.init(width: width, height: height)
        return size
    }
}
