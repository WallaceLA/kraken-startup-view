//
//  ListaConfirmacoesTableViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 11/10/20.
//  Copyright © 2020 Parken. All rights reserved.
//

import UIKit
import CoreData

class ListaConfirmacoesTableViewController: UITableViewController {
    
    var requisicoes:[NSManagedObject] = []
    var vagas:[NSManagedObject] = []
    
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Requisicao")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
        
        let fetchRequestVaga = NSFetchRequest<NSManagedObject>(entityName: "Vaga")
        //fetchRequestVaga.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "rua", ascending: true)]
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "numero", ascending: true)]
        
        do {
            requisicoes = try managedContext.fetch(fetchRequest)
            vagas = try managedContext.fetch(fetchRequestVaga)
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
        return requisicoes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let requisicao = requisicoes[indexPath.row]
        //let vaga = vagas[indexPath.row]
        
        //cell.textLabel?.text = vagas[indexPath.row]
        //cell.imageView?.image = UIImage(color: .red)
        //var idFinal:String = ""
        
        let idRequisicao = requisicao.value(forKeyPath: "id") as? String ??  "N/D"
        
        for vaga in vagas{
            
            let titulo = vaga.value(forKeyPath: "titulo") as? String ??  "Titulo"
            let rua = vaga.value(forKeyPath: "rua") as? String ??  "Rua"
            let numero = vaga.value(forKeyPath: "numero") as? String ??  "N/D"
            let cep = vaga.value(forKeyPath: "cep") as? String ??  "N/D"
            
            let idVaga = "\(rua)-\(numero)-\(cep)-\(titulo)"
            
            if idRequisicao == idVaga{
                //idFinal = idVaga
            
                let endereco:String = "\(titulo) - \(rua), \(numero)"
                
                cell.textLabel?.text = endereco
                cell.detailTextLabel?.text = requisicao.value(forKeyPath: "data") as? String
                
                break
            }
            
        }
        
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
        
        if(segue.identifier == "segueConfirmacao"){
            let vc = segue.destination as! ConfirmarVagaViewController
            let vagaSelecionada:NSManagedObject = requisicoes[self.tableView.indexPathForSelectedRow!.item]
            vc.requisicao = vagaSelecionada
        }
        
     }

    
}
