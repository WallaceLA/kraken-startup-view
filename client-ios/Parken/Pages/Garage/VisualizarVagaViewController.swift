//
//  VisualizarVagaViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 29/09/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class VisualizarVagaViewController: UIViewController {

    var vaga:NSManagedObject? = nil
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var lblEndereco: UILabel!
    @IBOutlet weak var lblCidade: UILabel!
    @IBOutlet weak var lblTamanho: UILabel!
    
    @IBOutlet weak var buttonFrequencia: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (vaga != nil){
            lblStatus.text = vaga?.value(forKeyPath: "reservado") as? String ?? "Reservada"
            if(lblStatus.text == "true"){
                lblStatus.tintColor = UIColor.green
            } else {
                lblStatus.tintColor = UIColor.red
            }
            
            lblTitulo.text = vaga?.value(forKeyPath: "titulo") as? String ??  "Titulo"
            lblDescricao.text = vaga?.value(forKeyPath: "descricao") as? String ?? "Descricao"
                        
            let rua = vaga?.value(forKeyPath: "rua") as? String ?? "Rua"
            let num = vaga?.value(forKeyPath: "numero") as? String ?? "N/D"
            let compl = vaga?.value(forKeyPath: "complemento") as? String ?? ""
            lblEndereco.text = "\(rua), \(num) \(compl)"
            
            let cid = vaga?.value(forKeyPath: "cidade") as? String ?? "Cidade"
            let uf = vaga?.value(forKeyPath: "uf") as? String ?? "UF"
            let cep = vaga?.value(forKeyPath: "cep") as? String ?? "00000-000"
            lblCidade.text = "\(cid) - \(uf) | CEP: \(cep)"
            
            let alt = vaga?.value(forKeyPath: "altura") as? String ?? "0m"
            let lar = vaga?.value(forKeyPath: "largura") as? String ?? "0m"
            let com = vaga?.value(forKeyPath: "comprimento") as? String ?? "0m"
            lblTamanho.text = "\(lar)m x \(com)m x \(alt)"
            
            //buttonFrequencia.setTitle("TODO", for: .normal)
        }

        // Do any additional setup after loading the view.
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
