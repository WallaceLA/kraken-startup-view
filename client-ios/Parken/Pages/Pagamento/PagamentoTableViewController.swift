//
//  PagamentoTableViewController.swift
//  Parken
//
//  Created by Gabriel Gobbo on 02/10/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class PagamentoTableViewController: UITableViewController {

    var cartoes : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()}
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cartao")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "cartaoNome", ascending: true)]
        
        do{
            cartoes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("nao foi possivel buscar os dados \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cartoes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cartao = cartoes[indexPath.row]
        
        cell.textLabel?.text = cartao.value(forKeyPath: "cartaoNome") as? String
        cell.detailTextLabel?.text  = cartao.value(forKeyPath: "cartaoNum") as? String

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext

            managedContext.delete(cartoes[indexPath.row])
            
            do{
                try managedContext.save()
                cartoes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError{
                print("nao foi possivel excluir o registro \(error), \(error.userInfo)")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "abc"{
            let vc = segue.destination as! PagamentoViewController
            let cartaoSelecionado:NSManagedObject = cartoes[self.tableView.indexPathForSelectedRow!.item]
            vc.cartoes = cartaoSelecionado
            //print(cartaoSelecionado)
        }
    }


}
