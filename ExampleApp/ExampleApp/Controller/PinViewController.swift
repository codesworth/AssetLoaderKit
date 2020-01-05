//
//  PinViewController.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 02/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit
import AssetLoader


class PinViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    private var dataController:PinDataController<DataService<MindValleyPins>>!
    private var service:DataService<MindValleyPins>!
    fileprivate var transition = Animator()
    var selectedCell:PinCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        service = DataService()
        collectionView.register(UINib(nibName: PinCell.Identifier, bundle: nil), forCellWithReuseIdentifier: PinCell.Identifier)
        dataController = PinDataController(service: service, collectionView: collectionView)
        dataController.owner = self
        dataController.delegate = self
        dataController.fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    


}


extension PinViewController:PinDataControllerDelegate{
    
    func didSelectPin(_ pin: MindValleyPin, with image: UIImage?, for cell:PinCell) {
        selectedCell = cell
        if let fullVc = storyboard?.instantiateViewController(withIdentifier: PhotoFullScreenVC.Identifier) as? PhotoFullScreenVC{
            fullVc.pin = pin
            //fullVc.modalPresentationStyle = .fullScreen
            fullVc.transitioningDelegate = self
            fullVc.placeHolderImage = image
            present(fullVc, animated: true, completion: nil)
        }
    }
    
}


extension PinViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let cell = selectedCell, let selectedParent = selectedCell?.superview else {return nil}
        transition.startingFrame = selectedParent.convert(cell.frame, to: nil)

        //transition.startingFrame = CGRect(x: transition.startingFrame.origin.x - 20, y: transition.startingFrame.origin.y + 20, width: transition.startingFrame.size.wi, height: transition.startingFrame.size.height - 40)
        transition.isPresenting = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
        
    }
}
