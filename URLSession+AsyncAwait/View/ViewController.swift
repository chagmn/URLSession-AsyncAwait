//
//  ViewController.swift
//  URLSession+AsyncAwait
//
//  Created by ChangMin on 2022/12/17.
//

import UIKit

import SnapKit

final class ViewController: UIViewController {

    private var imageArr: [Image] = []
    private var page: Int = 0
    
    private lazy var imageCollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        fetchImages()
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
    
    func fetchImages() {
        page += 1
        
        Task {
            do {
                let imageData = try await NetworkService.fetchImage(page: page)
                page == 1 ? imageArr = imageData : imageArr.append(contentsOf: imageData)
                imageCollectionView.reloadData()
                
            } catch FetchError.invaildServerResponse {
                print("FetchError - invaildServerResponse")
            } catch FetchError.invaildURL {
                print("FetchError - invaildURL")
            }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.window?.windowScene?.screen.bounds.width)!
        return CGSize(width: width-20, height: 500)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
                
        if imageArr.count <= 0 { return cell }
        let downloadURLStr: String = imageArr[indexPath.row].links.downloadURL
        let imageDownloadURL = URL(string: downloadURLStr)!
        
        if let cachedImage = ImageCacheManager.shared.cachedImage(urlString: downloadURLStr) {
            print("캐싱 ", indexPath.row)
            cell.imageView.image = cachedImage
            return cell
        }
        
        URLSession.shared.dataTask(with: imageDownloadURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                
            } else if let data = data {
                DispatchQueue.main.async {
                    ImageCacheManager.shared.setObject(image: UIImage(data: data)!, urlString: downloadURLStr)
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        return cell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let imageUrl: String = imageArr[indexPath.row].links.downloadURL
            print("prefetch ", indexPath.row)
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCell.identifier,
                for: indexPath
            ) as? PhotoCell else { return }
            
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: URL(string: imageUrl)!) else { return }
                
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
            }
          
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottomHeight = contentHeight - yOffset
        
        let frameHeight = scrollView.frame.size.height
        if heightRemainBottomHeight < frameHeight {
            fetchImages()
        }
    }
}
