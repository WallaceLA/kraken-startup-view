//
//  ChatViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 05/10/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var txtMensagem: UITextField!
    @IBOutlet weak var buttonEnviar: UIButton!    
    
    @IBOutlet weak var scrollHistorico: UIScrollView!
    
    
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
