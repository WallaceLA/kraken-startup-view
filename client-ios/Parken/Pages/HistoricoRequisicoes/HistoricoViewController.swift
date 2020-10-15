//
//  HistoricoViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 13/10/20.
//  Copyright © 2020 Parken. All rights reserved.
//

import UIKit
import CoreData

class HistoricoViewController: UIViewController {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var veiculo: UILabel!
    @IBOutlet weak var placa: UILabel!
    
    
    var solicitacao:NSManagedObject? = nil
    
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (solicitacao != nil) {
            id.text = solicitacao?.value(forKeyPath: "id") as? String ?? "ID nulo"
            
            estado.text = solicitacao?.value(forKeyPath: "estado") as? String ?? "Pendente"
            
            df.dateFormat = "dd-MM-yyyy HH:mm"
            let dataReq = df.string(from: solicitacao?.value(forKeyPath: "data") as! Date)
            data.text = dataReq
            
            nome.text = solicitacao?.value(forKeyPath: "solicitante") as? String ?? "Não encontrado"
                
            veiculo.text = solicitacao?.value(forKeyPath: "veiculo") as? String ?? "Não encontrado"
            
            placa.text = solicitacao?.value(forKeyPath: "placa") as? String ?? "Não encontrado"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
