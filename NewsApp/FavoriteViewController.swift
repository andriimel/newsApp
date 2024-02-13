//
//  FavoriteViewController.swift
//  NewsApp
//
//  Created by Andrii Melnyk on 1/25/24.
//

import UIKit
import CoreData
import SwiftUI

class FavoriteViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate{
 
    var favorite : [Favorite]?
    var searchNews : [Favorite]?
    private  var newsTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationItem.title = "Favorite"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
        
        let barHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        newsTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        newsTableView.register(NewsAppCell.self,forCellReuseIdentifier:  NewsAppCell.identifier)
        newsTableView.rowHeight = 80
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        self.initSearchController()
        
        
        self.view.addSubview(newsTableView)
        
    }
    
    @objc func backButtonPressed() {
        print ("back button pressed")
        let mainVC = MainViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
        
    }
    // MARK: - Core data methods
    
    func deleteNewsFormList(cell : UITableViewCell) {
        
        let indexPathTapped = newsTableView.indexPath(for: cell)
        deleteNews(with: indexPathTapped!.row)
    }
    
    func deleteNews(with newsIndex: Int) {
        let newsToRemove = self.favorite![newsIndex]
        newsToRemove.favorites?.isLike = false
        self.context.delete(newsToRemove)
        
        self.saveNews()
        
        self.fetchNews()
    }
    
    func saveNews(){
        do {
            try self.context.save()
        } catch {
            print ("Isues with saving news",error)
        }
        
        self.fetchNews()
    }
    
    func fetchNews() {
        
        do {
            let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            let pred = NSPredicate(format: "favorites.isLike == %d", true )
            request.predicate = pred
            self.favorite = try context.fetch(request)
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    func initSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search ... "
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchBar.delegate = self
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        print("Debug PRINT", searchController.searchBar.text)
        let searchBar = searchController.searchBar
        guard  let searchText = searchBar.text else {return}
        if searchText == "" {
            return fetchNews()
        }
        do {
           
            let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            let pred = NSPredicate(format: "source CONTAINS[cd] %@", searchText )
            request.predicate = pred
            self.favorite = try context.fetch(request)
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsAppCell.identifier, for: indexPath as IndexPath) as! NewsAppCell
        cell.favoriteCell = self
        let url = URL(string: favorite![indexPath.row].imgURL ?? "")
        if url == nil {
            print ("Oops image doesnt exist")
            
        } else{
            cell.logoImageView.sd_setImage(with: url)
        }
        cell.newsTitleLabel.text = favorite![indexPath.row].title
        cell.newsSourceNameLabel.text = favorite![indexPath.row].source
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = favorite![indexPath.row].url else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.deleteNews(with: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    


}

