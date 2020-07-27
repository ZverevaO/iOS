//
//  NewsTableView.swift
//  ApplicationVK
//
//  Created by Оксана Зверева on 27.07.2020.
//  Copyright © 2020 Oksana Zvereva. All rights reserved.
//

import UIKit
import AlamofireImage
import Foundation


class NewsTableView: UITableViewController {
    
    private var newsList: DataNews?
    private let dateFormatter = DateFormatter()
    
    private let dataNewsService = DataNewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataNewsService.loadPartDataNews(startFrom: "", comletion: { [weak self] newsData, error, from in
            guard let _ = error else {
                self?.newsList = newsData
                
                self?.tableView.reloadData()
                
                return
            }
            
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return newsList?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case  0: do {//.autur: do {
            //ячейка для вывода автора новости
            let  cell = tableView.dequeueReusableCell(withIdentifier: "NewsAutorTableViewCell", for: indexPath) as! NewsAutorTableViewCell
            
            
            return cell
            }
            
        case 1: do { //.text: do {
            //ячейка для вывода текста новости
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextTableViewCell", for: indexPath) as! NewsTextTableViewCell
            
            return cell
            }
            
        case 2: do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoTableViewCell", for: indexPath) as! NewsPhotoTableViewCell
            return cell
            
            }
        case 3: do { //.footer: do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterTableViewCell", for: indexPath) as! NewsFooterTableViewCell
            return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterTableViewCell", for: indexPath) as! NewsFooterTableViewCell
            return cell
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
