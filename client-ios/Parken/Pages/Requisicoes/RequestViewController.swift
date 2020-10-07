//
//  RequestViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 05/10/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit

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
