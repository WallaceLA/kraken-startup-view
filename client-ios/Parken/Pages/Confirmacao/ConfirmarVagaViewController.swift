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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actAprovar(_ sender: Any) {
    }
    
    @IBAction func actRejeitar(_ sender: Any) {
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
