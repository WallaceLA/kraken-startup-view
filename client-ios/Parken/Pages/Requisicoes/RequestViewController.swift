//
//  RequestViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 05/10/20.
//  Copyright © 2020 Parken. All rights reserved.
//

import UIKit
import CoreData

class RequestViewController: UIViewController {

    @IBOutlet weak var buttonCancelar: UIBarButtonItem!
    
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lglDescricao: UILabel!
    
    @IBOutlet weak var lblEndereco: UILabel!
    @IBOutlet weak var lblCidadeEstado: UILabel!
    
    @IBOutlet weak var lblTamanho: UILabel!
        
    @IBOutlet weak var stepHoras: UIStepper!
    @IBOutlet weak var lblHoras: UILabel!
    
    @IBOutlet weak var lblCusto: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    var vaga : NSManagedObject?

    var valorHora:Double = 0.0
    var qtdHora:Double = 1.0
    var valorTotal:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if (vaga != nil){
            
            lblTitulo.text = vaga?.value(forKeyPath: "titulo") as? String ??  "Titulo"
            lglDescricao.text = vaga?.value(forKeyPath: "descricao") as? String ?? "Descricao"
                        
            let rua = vaga?.value(forKeyPath: "rua") as? String ?? "Rua"
            let num = vaga?.value(forKeyPath: "numero") as? String ?? "N/D"
            let compl = vaga?.value(forKeyPath: "complemento") as? String ?? ""
            lblEndereco.text = "\(rua), \(num) \(compl)"
            
            let cid = vaga?.value(forKeyPath: "cidade") as? String ?? "Cidade"
            let uf = vaga?.value(forKeyPath: "uf") as? String ?? "UF"
            let cep = vaga?.value(forKeyPath: "cep") as? String ?? "00000-000"
            lblCidadeEstado.text = "\(cid) - \(uf) | CEP: \(cep)"
            
            let alt = vaga?.value(forKeyPath: "altura") as? String ?? "0m"
            let lar = vaga?.value(forKeyPath: "largura") as? String ?? "0m"
            let com = vaga?.value(forKeyPath: "comprimento") as? String ?? "0m"
            lblTamanho.text = "\(lar)m x \(com)m x \(alt)"
            
            valorHora = vaga?.value(forKeyPath: "valor") as? Double ?? 1.0
            
            lblCusto.text = "R$ \(valorHora) por Hora"
        } else {
            lblTitulo.text = "VAGA NULA"
        }
        
        //qtdHora = Double(lblHoras.text ?? "1")!
        
        //valorTotal = valorHora * qtdHora
        
        //lblTotal.text = "Total: R$ \(valorTotal)"

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func definirHora(_ sender: Any) {
        qtdHora = stepHoras.value
        
        lblHoras.text = "\(qtdHora)"
        
        valorTotal = valorHora * qtdHora
        lblTotal.text = "Total: R$ \(valorTotal)"
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
