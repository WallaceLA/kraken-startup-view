//
//  CheckoutPlanoViewController.swift
//  Parken
//
//  Created by Wallace Aguiar and Gabriel Gobbo on 06/10/20.
//  Copyright © 2020 ParKen. All rights reserved.
//

import UIKit
import CoreData

class CheckoutPlanoViewController: UIViewController {

    @IBOutlet weak var lblNomePlano: UILabel!
    @IBOutlet weak var lblValor: UILabel!
    
    @IBOutlet weak var lblNumCartao: UILabel!
    @IBOutlet weak var lblVencCartao: UILabel!
    @IBOutlet weak var lblNomeCartao: UILabel!
    
    @IBOutlet weak var buttonConfirmar: PrimaryButtonStyle!
    
    var cartoes : [NSManagedObject] = []
    
    var nomePlano:String = "Plano"
    var valorPlano:String = "R$ 199,91"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cartao")

                fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "cartaoNum", ascending: false)]
                fetchRequest.fetchLimit = 1

                do {
                    cartoes = try managedContext.fetch(fetchRequest)
                } catch let error as NSError {
                    print("Não foi possível buscar os dados \(error), \(error.userInfo)")
                }

        let num = cartoes[0].value(forKeyPath: "cartaoNum") as? String ??  "***1234"
        lblNumCartao.text = String(num.suffix(4))
        
        lblNomeCartao.text = cartoes[0].value(forKeyPath: "cartaoNome") as? String ??  "Não encontrado"
        
        lblVencCartao.text = cartoes[0].value(forKeyPath: "cartaoData") as? String ??  "Não encontrado"
        
        lblNomePlano.text = nomePlano
        
        lblValor.text = "Valor Mensal R$ \(valorPlano)"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmar(_ sender: Any) {
        
        let alerta = UIAlertController(
                               title: "Sucesso!" ,
                               message: "Pagamento confirmado.",
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
