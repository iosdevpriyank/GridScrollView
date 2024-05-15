//
//  ScrollableGridViewController.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 08/05/24.
//

import UIKit

class ScrollableGridViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    //MARK: Variables
    
    //MARK: Private Variables
    private var scrollableGridViewModel: ScrollableGridViewModel?
    
    //MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModels()
        callAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Methods
    private func setupUI() {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    private func setupViewModels() {
        scrollableGridViewModel = ScrollableGridViewModel()
        
        scrollableGridViewModel?.reloadingViews = { [weak self] in
            DispatchQueue.main.async {
                self?.imageCollectionView.reloadData()
            }
        }
    }
    
    private func callAPI() {
        scrollableGridViewModel?.getAPIGridForImages(Constant.API.limit)
    }
    
    
    
    //MARK: IBActions

}


//MARK: Extensions

extension ScrollableGridViewController: UICollectionViewDelegate {
    
}

extension ScrollableGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scrollableGridViewModel?.arrImageURLS.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CollectionView.cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let strURL = scrollableGridViewModel?.arrImageURLS[indexPath.item] ?? ""
        imageCell.setupCellConfiguration(imageURL: strURL, for: indexPath)
        return imageCell
    }
}

extension ScrollableGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = CGFloat(5)
        let availableWidth = imageCollectionView.frame.width - padding * CGFloat(Constant.CollectionView.maxColumn + 1)
        let widthOfItem = availableWidth / CGFloat(Constant.CollectionView.maxColumn)
        return CGSize(width: widthOfItem, height: widthOfItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        ImageLoader.shared.loadingTasks[indexPath.item].cancel()
    }
}
