//
//  VagasTableViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 23/09/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class VagasTableViewController: UITableViewController {

    var vagas : [NSManagedObject] = []
    //Listar todas as vagas.
    
    //A string abaixo é só para testar, n considerar.
    //var vagas:[String] = ["Teste", "Hosp. Sapopemba"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vaga")

        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "titulo", ascending: true)]
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "rua", ascending: true)]
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "numero", ascending: true)]

        do {
            vagas = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Não foi possível buscar os dados \(error), \(error.userInfo)")
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
        return vagas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let vaga = vagas[indexPath.row]

        //cell.textLabel?.text = vagas[indexPath.row]
        //cell.imageView?.image = UIImage(color: .red)
        
        let rua = vaga.value(forKeyPath: "rua") as? String ?? "Rua não encontrada"
        let num = vaga.value(forKeyPath: "numero") as? String ?? "Sem Número"
        let compl = vaga.value(forKeyPath: "complemento") as? String ?? ""
        let endereco:String = "\(rua), \(num) \(compl)"
        
        //, \(vaga.value(forKeyPath: "numero"))"
        // Configure the cell...
        cell.textLabel?.text = vaga.value(forKeyPath: "titulo") as? String
        cell.detailTextLabel?.text = endereco

        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "VisualizarVagaSegue"){
            let vc = segue.destination as! VisualizarVagaViewController
            let vagaSelecionada:NSManagedObject = vagas[self.tableView.indexPathForSelectedRow!.item]
            vc.vaga = vagaSelecionada
        }
    }
    
    
}
