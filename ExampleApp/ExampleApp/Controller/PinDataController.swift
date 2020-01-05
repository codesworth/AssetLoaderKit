//
//  PinDataController.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 03/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit
import AssetLoader


protocol PinDataControllerDelegate:class {
    
    func didSelectPin(_ pin:MindValleyPin, with image:UIImage?, for cell:PinCell)
}

class PinDataController<ServiceObject:DataServiceProtocol>: NSObject, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    typealias MindValleyPins = [MindValleyPin]
    weak var collectionView:UICollectionView?
    weak var owner:UIViewController?
    var pins:MindValleyPins = []
    private var service:ServiceObject
    let refreshControl = UIRefreshControl()
    var flowLayout:PinCellsLayout?
    private var cursor:Cursor!
    weak var delegate:PinDataControllerDelegate?
    init(service:ServiceObject, collectionView:UICollectionView?, cursor:Cursor? = nil) {
        self.collectionView = collectionView
        self.service = service
        if let cursor = cursor {self.cursor = cursor}
        super.init()
        setup()
    }
    
    func setup(){
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        if let layout = collectionView?.collectionViewLayout as? PinCellsLayout{
            flowLayout = layout
            layout.delegate = self
        }
        
        refreshControl.tintColor = UIColor.systemPurple
        let attrs:[NSAttributedString.Key:Any] = [.foregroundColor:UIColor.systemPurple]
        refreshControl.attributedTitle = NSAttributedString(string:"Reloading Pins",attributes: attrs)
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc func fetchData(){
        cursor = Cursor(limit: 10)
        service.fetchData(url: Constants.dataUrl, with: cursor) {[weak self] (result) in
            guard let self = self else {return}
            self.resolveResult(result: result, changeCursor: false)
            
        }
    }
    
    func resolveResult(result:Result<ServiceObject.DataType, NetworkError>, changeCursor:Bool){
        refreshControl.endRefreshing()
        switch result{
        case .failure(let err):
            let alert = UIAlertController(title: "Error", message: err.customDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.owner?.present(alert, animated: true, completion: nil)
            break
        case .success(let pins):
            if let mindvalleyPins = pins as? MindValleyPins{
                if mindvalleyPins.isEmpty{
                    return
                }
                var indexPaths:[IndexPath] = []
                if changeCursor{
                    indexPaths = mindvalleyPins.enumerated().compactMap{IndexPath(row: $0.offset + self.pins.count, section: 0)}
                    self.pins += mindvalleyPins.shuffled()
                    self.flowLayout?.invalidateLayout()
                }else{
                    indexPaths = mindvalleyPins.enumerated().compactMap{IndexPath(row: $0.offset, section: 0)}
                    self.pins = mindvalleyPins.shuffled()
                }
               collectionView?.performBatchUpdates({
                   collectionView?.insertItems(at: indexPaths)
               })
            }
        }
    }
    
    func fetchMoreData(){
        cursor.next()
        service.fetchData(url: Constants.dataUrl, with: cursor) {[weak self] (result) in
            guard let self = self else {return}
            self.resolveResult(result: result, changeCursor: true)
        }
    }
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinCell.Identifier, for: indexPath) as? PinCell{
            let pin = pins[indexPath.row]
            cell.configure(pin, manager: service.assetManager, for: indexPath.row )
            return cell
        }
        return PinCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         guard let collectionView = collectionView else {return}
                   //print("ContentSize",collectionView.contentSize.height)
          let contentOffsetY = scrollView.contentOffset.y
          let currentHeight = Int(contentOffsetY) + Int(collectionView.frame.height)
          if currentHeight > Int(collectionView.contentSize.height + 100) {
              fetchMoreData()
          }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pin = pins[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! PinCell
        let image = cell.imageView.image
        delegate?.didSelectPin(pin, with: image, for: cell)
    }

    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        service.assetManager.cancel(for: indexPath.row)
    }
    
}



extension PinDataController:PinCellsLayoutDelegate{
    func heightForItem(at indexPath: IndexPath, for width: CGFloat) -> CGFloat {
        let pin  = pins[indexPath.row]
        let calulator = SizeCalulator(width: pin.width, height: pin.height, standardWidth: width)
        return calulator.size.height
    }
    
}
