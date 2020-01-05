//
//  PhotoFullScreenVC.swift
//  ExampleApp
//
//  Created by Shadrach Mensah on 04/01/2020.
//  Copyright © 2020 Shadrach Mensah. All rights reserved.
//

import UIKit


class PhotoFullScreenVC:UIViewController{
    
    
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    var originalFrame:CGRect!
    
    var pin:MindValleyPin?
    var placeHolderImage:UIImage?
    var canHideContainer = true
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        attachPangesture()
        
        view.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        blurview.effect = blurEffect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        originalFrame = view.frame
    }
    
    @objc func tapped(_ recognizer:UITapGestureRecognizer){
        if canHideContainer{
            canHideContainer = false
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {[unowned self] in
                self.containerView.alpha = 0
            })
            
        }else{
            canHideContainer = true
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {[unowned self] in
                self.containerView.alpha = 1
            })
        }
    }
    
    func updateView(){
        guard let pin = pin else {return}
        blurImageView.image = placeHolderImage
        usernameLable.text = pin.user.username
        fullNameLabel.text = pin.user.name.capitalized
        likesLabel.text = "\(pin.likes)"
        categoryLabel.text = pin.categories.first?.title
        if let profileUrl = pin.user.profileThumbNailUrl{
            userProfileImageView.setImage(for: profileUrl)
        }
//        if let fullUrl = pin.urls.fullUrl{
//            fullScreenImageView.setImage(for: fullUrl, placeHolder: placeHolderImage)
//        }
        
        
        
    }
    
    func attachPangesture(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func panned(_ recognizer:UIPanGestureRecognizer){
        
        guard let view = recognizer.view else {return}
        
        let translation = recognizer.translation(in: view)
        
        let finalPoint = view.frame.origin + translation
        view.frame.origin.y = max(finalPoint.y, 120)
        view.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.height, height: view.frame.height))
        view.frame.size = CGSize(width: max(view.frame.width - (translation.y * 2), 40), height: max(view.frame.height - (translation.y * 2), 40))
        view.center = CGPoint(x: originalFrame.midX, y: originalFrame.midY)
        if view.frame.width == 40 {view.center  = view.center + translation}
        view.layer.cornerRadius = view.frame.width / 2
        if recognizer.state == .began{
            containerView.isHidden = true
        }
        if recognizer.state == .ended{
            if  view.frame.width < 300 {
                fullScreenImageView.contentMode = .scaleAspectFill
                dismiss(animated: true, completion: nil)
            }else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                    view.layer.cornerRadius = 0
                    view.frame = self.originalFrame
                    self.containerView.isHidden = false
                }, completion: nil)
            }
        }
        recognizer.setTranslation(.zero, in: view)
    }
    
}


extension PhotoFullScreenVC:Identity{}
