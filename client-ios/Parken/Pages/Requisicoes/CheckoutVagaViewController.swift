//
//  CheckoutVagaViewController.swift
//  Parken
//
//  Created by Gabriel Gobbo on 10/10/20.
//  Copyright © 2020 Parken. All rights reserved.
//

import UIKit
import CoreData

class CheckoutVagaViewController: UIViewController {

    @IBOutlet weak var lblVaga: UILabel!
    
    @IBOutlet weak var lblValor: UILabel!
    
    @IBOutlet weak var lblNumCartao: UILabel!
    @IBOutlet weak var lblVencCartao: UILabel!
    @IBOutlet weak var lblNomeCartao: UILabel!
    
    @IBOutlet weak var buttonConfirmar: PrimaryButtonStyle!
    
    var cartoes : [NSManagedObject] = []
    var requisicoes : NSManagedObject?
    
    var nomeVaga:String = "Titulo Vaga"
    var valorVaga:String = "R$ 00,00"
    
    var dataHora:Date?
    var marca:String?
    var modelo:String?
    var placa:String?
    var qtdHoras:Double?
    
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
        
        lblVaga.text = nomeVaga
        
        lblValor.text = "R$ \(valorVaga)"

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
        // Do any additional setup after loading the view.
    
    func save(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
          
        let managedContext = appDelegate.persistentContainer.viewContext
        let entidade = NSEntityDescription.entity(forEntityName: "Requisicao", in: managedContext)!
        let objUpdate = NSManagedObject(entity: entidade, insertInto: managedContext)
        
        let veiculo = "\(marca ?? "marca") \(modelo ?? "modelo")"
        let solicitante = "Tiago"
        let estado = "Pendente"
        
        //let objUpdate = requisicoes
        objUpdate.setValue(dataHora, forKeyPath: "data")
        objUpdate.setValue(placa, forKeyPath: "placa")
        objUpdate.setValue(veiculo, forKeyPath: "veiculo")
        objUpdate.setValue(solicitante, forKeyPath: "solicitante")
        objUpdate.setValue(qtdHoras, forKeyPath: "qtdHoras")
        objUpdate.setValue(estado, forKeyPath: "estado")

        do{
            try managedContext.save()
        } catch let error as NSError{
            print("nao foi possivel salvar \(error), \(error.userInfo)")
        }
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
