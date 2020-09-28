//
//  VisualizarVagasTableViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 27/09/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class VisualizarVagasTableViewController: UITableViewController {

     var vagas: [NSManagedObject] = []

       override func viewWillAppear(_ animated: Bool) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
           let managedContext = appDelegate.persistentContainer.viewContext
         
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vaga")
           
           fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "titulo", ascending: true)]
           //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "rua", ascending: true)]
           //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "numero", ascending: true)]
           //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "frequencia", ascending: true)]
           //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "descricao", ascending: true)]
        
           do {
               vagas = try managedContext.fetch(fetchRequest)
           } catch let error as NSError {
               print("Não foi possível buscar os dados \(error), \(error.userInfo)")
           }
           self.tableView.reloadData()
       }

       override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return vagas.count
       }
    
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let vaga = vagas[indexPath.row]
        
            let endereco = "\(vaga.value(forKeyPath: "rua") ?? "Rua"), \(vaga.value(forKeyPath: "numero") ?? "000")"
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                   
            cell.textLabel?.text = vaga.value(forKeyPath: "titulo") as? String
            cell.detailTextLabel?.text = endereco
            //cell.textLabel?.text = vaga.value(forKeyPath: "frequencia") as? String
            //cell.textLabel?.text = vaga.value(forKeyPath: "descricao") as? String
            return cell
       }

       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Delete the row from the data source
               guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
               let managedContext = appDelegate.persistentContainer.viewContext
             
               managedContext.delete(vagas[indexPath.row])
               do {
                   try managedContext.save()
                   vagas.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .fade)
               } catch let error as NSError {
                   print("Não foi possível excluir o registro \(error), \(error.userInfo)")
               }
               
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
