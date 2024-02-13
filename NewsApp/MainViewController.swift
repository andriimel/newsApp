//
//  ViewController.swift
//  NewsApp
//
//  Created by Andrii Melnyk on 1/25/24.
//

import UIKit
import CoreData
import SwiftUI

class MainViewController: UIViewController, UITabBarControllerDelegate, UIGestureRecognizerDelegate {
    
    var newsManager = NewsManager()
    var articles: [Article] = []
    var news:[News]?
    
    let defaults = UserDefaults.standard
    var reloadNews : Bool = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tabBarVC = UITabBarController()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 35.0)
        label.textAlignment = .center
        
        
        return label
    }()
    
    let  scienceNewsButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.setTitle("Science", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.tag = 0
        return button
    }()
    let  sportNewsButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.setTitle("Sport", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.tag = 1
        return button
    }()
    
    
    let  healthNewsButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.setTitle("Health", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.tag = 2
        return button
    }()
    
    let  entertaimentNewsButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.setTitle("Entertainment", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.tag = 3
        return button
    }()
    
    let  favoriteNewsButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.setTitle("Favorite", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.tag = 4
        return button
    }()
    
    let logoImage:UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "logoNewsimg")
        return imageView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let xCoordinate = view.frame.width * 0.1
        let spaceBtwn = 20.0
        let buttonWidth = view.frame.width * 0.8
        let buttonHeight = 50.0
        
        logoImage.frame = CGRect(x: xCoordinate, y: view.frame.height * 0.1, width: buttonWidth, height: buttonWidth/2)
        logoLabel.frame = CGRect(x: xCoordinate,
                                 y: view.frame.height * 0.35,
                                 width: buttonWidth,
                                 height: buttonHeight)
        
        scienceNewsButton.frame = CGRect(x: xCoordinate,
                                         y: view.frame.height * 0.45,
                                         width: buttonWidth,
                                         height: buttonHeight)
        
        sportNewsButton.frame = CGRect(x: xCoordinate,
                                       y: scienceNewsButton.frame.maxY + spaceBtwn,
                                       width: buttonWidth,
                                       height: buttonHeight)
        
        healthNewsButton.frame = CGRect(x: xCoordinate,
                                        y: sportNewsButton.frame.maxY + spaceBtwn,
                                        width: buttonWidth,
                                        height: buttonHeight)
        entertaimentNewsButton.frame = CGRect(x: xCoordinate,
                                              y: healthNewsButton.frame.maxY + spaceBtwn,
                                              width: buttonWidth,
                                              height: buttonHeight)
        
        favoriteNewsButton.frame = CGRect(x: xCoordinate,
                                          y: entertaimentNewsButton.frame.maxY + spaceBtwn,
                                          width: buttonWidth,
                                          height: buttonHeight)
        
    }
    
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarVC.delegate = self
        
        view.backgroundColor = .white
        logoLabel.text = ""
        logoLabel.textColor = .lightGray
        logoLabel.font = UIFont.boldSystemFont(ofSize: 50)
        let titleText = "News Viewer"
        var index = 0.0
        
        for letter in titleText {
            
            Timer.scheduledTimer(withTimeInterval: 0.1 * index, repeats: false) {(timer) in
                self.logoLabel.text?.append(letter)
            }
            index += 1
        }
        
        reloadNews = defaults.bool(forKey: "MyNewsIsReload")
        
        view.addSubview(logoImage)
        view.addSubview(sportNewsButton)
        view.addSubview(scienceNewsButton)
        view.addSubview(favoriteNewsButton)
        view.addSubview(healthNewsButton)
        view.addSubview(entertaimentNewsButton)
        view.addSubview(logoLabel)
        
        sportNewsButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        scienceNewsButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        healthNewsButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        entertaimentNewsButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        favoriteNewsButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
      
     
    }
 
    func setTabBarController () {
        
        let scienceVC = UINavigationController(rootViewController: ScienceNewsViewController())
        let sportVC = UINavigationController(rootViewController: SportNewsViewController())
        let healthVC = UINavigationController(rootViewController: HealthViewController())
        let entertaimentVC = UINavigationController(rootViewController: EntertainmentViewController())
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        
        tabBarVC.setViewControllers([scienceVC,sportVC,healthVC,entertaimentVC,favoriteVC], animated: false)
        
        
        let images = ["globe.americas.fill", "figure.run.circle", "cross.case.circle", "star.square.on.square.fill", "heart"]
        let title = ["Science","Sport","Health","Entertainment","Favorite"]
        
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
            items[x].title = title[x]
        }
        
        tabBarVC.tabBar.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        tabBarVC.tabBar.tintColor = .darkGray
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.selectedItem?.badgeColor = .lightGray
        
        tabBarVC.tabBar.isUserInteractionEnabled = true
        
        // Swipe
        
        let leftSwipe = UISwipeGestureRecognizer(target: self  , action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self , action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        leftSwipe.numberOfTouchesRequired = 1
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = .right
        tabBarVC.view.addGestureRecognizer(leftSwipe)
        tabBarVC.view.addGestureRecognizer(rightSwipe)
    }

    // MARK: - Swipe method
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer ) {
        print("You touch me !!! ")
        if sender.direction == .left {
            self.tabBarVC.selectedIndex += 1
        }
        if sender.direction == .right {
            self.tabBarVC.selectedIndex -= 1
        }
    }

    // MARK: - Button pressed 
    @objc func buttonPressed(sender:UIButton) {
        setTabBarController()
        self.tabBarVC.selectedIndex = sender.tag
        present(tabBarVC,animated: true)
        
    }
}

