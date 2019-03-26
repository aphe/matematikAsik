//
//  ResultCollectionViewController.swift
//  MatematikAsik
//
//  Created by Afriyandi Setiawan on 25/03/19.
//  Copyright © 2019 Afriyandi Setiawan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ResultCollectionViewController: UICollectionViewController {
    
    var data: [Int64]?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = .random
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ResultCollectionViewCell
        cell?.backgroundColor = .random
        cell?.cellNumber.text = data?[indexPath.row].commaRepresentation
        return cell ?? UICollectionViewCell()
    }
}

extension ResultCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (data?[indexPath.row].commaRepresentation.count ?? 0) * 20, height: 50)
    }
}
