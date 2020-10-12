//
//  ConfirmarVagaViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 11/10/20.
//  Copyright © 2020 Parken. All rights reserved.
//

import UIKit
import CoreData

class ConfirmarVagaViewController: UIViewController {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblEndereco: UILabel!
    
    @IBOutlet weak var lblDataHora: UILabel!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblVeiculo: UILabel!
    @IBOutlet weak var lblPlaca: UILabel!
    @IBOutlet weak var lblTempo: UILabel!
    @IBOutlet weak var lblValorTotal: UILabel!
    
    var requisicao : NSManagedObject?
    var vagas : NSManagedObject?
    
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNome?.text = (requisicao?.value(forKeyPath: "solicitante") as? String) ?? "Nome"
        lblVeiculo?.text = (requisicao?.value(forKeyPath: "veiculo") as? String) ?? "Veiculo"
        lblPlaca?.text = (requisicao?.value(forKeyPath: "placa") as? String) ?? "Placa"
        //lblDataHora?.text = "\(String(describing: requisicao?.value(forKeyPath: "data") as? Date))"
        lblTempo?.text = "\(requisicao?.value(forKeyPath: "qtdHoras") as? Double ?? 0.0)"
        
        
        lblTitulo?.text = (vagas?.value(forKeyPath: "titulo") as? String)
        
        let rua = vagas?.value(forKeyPath: "rua") as? String ?? "Rua"
        let num = vagas?.value(forKeyPath: "numero") as? String ?? "N/D"
        let compl = vagas?.value(forKeyPath: "complemento") as? String ?? ""
        lblEndereco.text = "\(rua), \(num) \(compl)"
        
        lblValorTotal?.text = "\(requisicao?.value(forKeyPath: "valorTotal") as? Double ?? 0.0)"
        
        df.dateFormat = "dd-MM-yyyy HH:mm"
        let dataReq = df.string(from: requisicao?.value(forKeyPath: "data") as! Date)
        lblDataHora.text = dataReq
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actAprovar(_ sender: Any) {
        
        let alerta = UIAlertController(
                               title: "Sucesso!" ,
                               message: "Vaga Aprovada.",
                               preferredStyle: UIAlertController.Style.alert)

                           alerta.addAction(UIAlertAction(
                                               title: "OK",
                                               style: UIAlertAction.Style.default,
                                               handler: {_ in self.navigationController?.popToRootViewController(animated: true)}))

               present(alerta, animated: true, completion: nil)
        
    }
    
    @IBAction func actRejeitar(_ sender: Any) {
        
        let alerta = UIAlertController(
                               title: "Atenção!" ,
                               message: "Sua solicitação foi negada.",
                               preferredStyle: UIAlertController.Style.alert)

                           alerta.addAction(UIAlertAction(
                                               title: "OK",
                                               style: UIAlertAction.Style.default,
                                               handler: {_ in self.navigationController?.popToRootViewController(animated: true)}))

               present(alerta, animated: true, completion: nil)
        
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
