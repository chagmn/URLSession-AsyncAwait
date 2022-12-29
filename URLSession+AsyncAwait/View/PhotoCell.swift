//
//  PhotoCell.swift
//  URLSession+AsyncAwait
//
//  Created by ChangMin on 2022/12/17.
//

import UIKit

import SnapKit

final class PhotoCell: UICollectionViewCell {
    static let identifier = "photoCell"
    
    lazy var imageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemMint
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension PhotoCell {
    func setupData(downloadURLStr: String) {
        if let downloadURL = URL(string: downloadURLStr) {
            URLSession.shared.dataTask(with: downloadURL) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)

                } else if let data = data {
                    DispatchQueue.main.async { [weak self] in
                        ImageCacheManager.shared.setObject(image: UIImage(data: data)!, urlString: downloadURLStr)
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
