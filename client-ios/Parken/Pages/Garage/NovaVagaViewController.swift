//
//  NovaVagaViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 26/09/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class NovaVagaViewController: UIViewController {

    @IBOutlet weak var txtTitulo: UITextField!
    
    //Endereço
    @IBOutlet weak var txtCep: UITextField!
    @IBOutlet weak var txtRua: UITextField!
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var txtBairro: UITextField!
    @IBOutlet weak var txtCidade: UITextField!
    @IBOutlet weak var txtUF: UITextField!
    
    //Medidas
    @IBOutlet weak var txtLargura: UITextField!
    @IBOutlet weak var txtComprimento: UITextField!
    @IBOutlet weak var txtAltura: UITextField!
    
    //Horarios Disponiveis
    @IBOutlet weak var switchSegunda: UISwitch!
    @IBOutlet weak var switchTerca: UISwitch!
    @IBOutlet weak var switchQuarta: UISwitch!
    @IBOutlet weak var switchQuinta: UISwitch!
    @IBOutlet weak var switchSexta: UISwitch!
    @IBOutlet weak var switchSabado: UISwitch!
    @IBOutlet weak var switchDomingo: UISwitch!
    
    
    //Todos os itens interativos estão acima, esses itens serão usados para criar um novo objeto do tipo Vaga no CoreData (vide ultima aula de iOS)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
