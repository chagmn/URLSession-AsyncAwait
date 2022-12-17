//
//  ViewController.swift
//  URLSession+AsyncAwait
//
//  Created by ChangMin on 2022/12/17.
//

import UIKit

import SnapKit

final class ViewController: UIViewController {

    private lazy var imageCollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        
        let a = NetworkService()
        a.fetchImage()
    }
}

private extension ViewController {
    func setupView() {
        view.addSubview(imageCollectionView)
        
        imageCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
                
        return cell
    }
}
