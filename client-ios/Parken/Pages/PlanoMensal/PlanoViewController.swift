//
//  PlanoViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 06/10/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit

class PlanoViewController: UIViewController {

    
    @IBOutlet weak var buttonEssential: PrimaryButtonStyle!
    
    @IBOutlet weak var buttonGold: PrimaryButtonStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let seguinho = segue.destination as! CheckoutPlanoViewController
        
        if segue.identifier == "essentialSegue"{
            seguinho.nomePlano = "Plano Essential"
            seguinho.valorPlano = "149,90"
            
        } else if segue.identifier == "goldSegue"{
            seguinho.nomePlano = "Plano Gold"
            seguinho.valorPlano = "199,90"
        }
    }
}
