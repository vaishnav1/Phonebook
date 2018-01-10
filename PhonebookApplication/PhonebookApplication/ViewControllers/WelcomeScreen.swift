//
//  WelcomeScreen.swift
//  PhonebookApplication
//
//  Created by Vaishnav on 08/01/18.
//  Copyright © 2018 Vaishnav. All rights reserved.
//

import UIKit

class WelcomeScreen: UIViewController {

    //MARK: Variables
    var customGradient: CAGradientLayer!
    var timer: Timer!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        createGradientlayer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //MARK: To Animate
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        }
        
        //MARK: - Pause on the screen
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "ContactsListSTBID") as! ContactsListViewController
            self.navigationController?.pushViewController(nav, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil{
            timer.invalidate()
        }
        timer = nil
        self.navigationController?.navigationBar.isHidden = false

    }
    

    //MARK: - Functions
    
    func createGradientlayer() {
        customGradient = CAGradientLayer()
        customGradient.frame = self.view.bounds
        customGradient.colors = [UIColor(red:1.00, green:0.85, blue:0.61, alpha:1.0).cgColor, UIColor(red:0.10, green:0.33, blue:0.48, alpha:1.0).cgColor]
        customGradient.locations = [0.0, 1.0]
        customGradient.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        customGradient.endPoint = CGPoint.init(x: 1.0, y: 1.0)
        
        self.view.layer.insertSublayer(customGradient, below: self.backgroundView.layer)
    }
    
   //MARK: - Animate Loading
    
    @objc func animate(){
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.loadingImageView.transform = self.loadingImageView.transform.rotated(by: .pi/2)
        })
        { (finished) -> Void in
        }
    }

}
