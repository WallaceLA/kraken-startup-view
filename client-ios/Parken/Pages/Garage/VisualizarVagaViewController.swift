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
    
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var lblEndereco: UILabel!
    @IBOutlet weak var lblCidade: UILabel!
    @IBOutlet weak var lblTamanho: UILabel!
    @IBOutlet weak var lblCusto: UILabel!
    
    @IBOutlet weak var buttonFrequencia: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (vaga != nil){
                        
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
            
            let freq = vaga?.value(forKeyPath: "frequencia") as? Dictionary<String, Any>
            
            var dias:String = ""
            
            for (dia, status) in freq! {
                print("Dia \(dia) - Status: \(status)")
                
                if(status as? Int == 1){
                    dias += " \(dia.prefix(3)),"
                }
            }
            
            let custo = vaga?.value(forKeyPath: "valor") as? Double ?? 12.22
            lblCusto.text = "R$ \(String(format: "%.2f", ceil(custo * 100)/100))"
            
            dias = String(dias.dropLast(1))
            
            buttonFrequencia.setTitle(dias, for: .normal)
        }

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "attFreqSegue"{
            let vc = segue.destination as! AtualizarFrequenciaViewController
            vc.vaga = vaga
        }
        
    }
    

}
