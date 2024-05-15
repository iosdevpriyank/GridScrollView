//
//  ScrollableGridViewModel.swift
//  ScrollableGrid
//
//  Created by Priyank Gandhi on 08/05/24.
//

import Foundation

class ScrollableGridViewModel {
    
    
    private (set) var arrImageURLS: [String] = []
    
    var reloadingViews:(()-> Void)?
    
    init() {
        
    }
    
    func getAPIGridForImages(_ limit: Int) {
        APIManager.callAPI(.media_coverages, type: ScrollableGrid.self, parameters: ["limit":"\(limit)"]) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageURLSStore(data.map({$0.thumbnail}))
            case .failure(let failure):
                print("\(failure.localizedDescription)")
            }
        }
    }
    
    func imageURLSStore(_ tumbnails: [Thumbnail]) {
        tumbnails.forEach { tumbnail in
            let strImageURL = tumbnail.domain + "/" + tumbnail.basePath + "/0/" + tumbnail.key
            arrImageURLS.append(strImageURL)
        }
        reloadingViews?()
    }
}
