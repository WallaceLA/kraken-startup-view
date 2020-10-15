//
//  PagamentoViewController.swift
//  Parken
//
//  Created by Gabriel Gobbo on 01/10/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class PagamentoViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var cartaoNome: UITextField!
    @IBOutlet weak var cartaoNum: UITextField!
    @IBOutlet weak var cartaoData: UITextField!
    @IBOutlet weak var cartaoCod: UITextField!
    
    var cartoes : NSManagedObject?=nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartaoNome.delegate = self
        cartaoNum.delegate = self
        cartaoData.delegate = self
        cartaoCod.delegate = self

        if (cartoes != nil){
            

            cartaoNome?.text = cartoes?.value(forKeyPath: "cartaoNome") as! String
            cartaoNum?.text = cartoes?.value(forKeyPath: "cartaoNum") as! String
            cartaoData?.text = cartoes?.value(forKeyPath: "cartaoData") as! String
            cartaoCod?.text = cartoes?.value(forKeyPath: "cartaoCod") as! String

        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func salvar(_ sender: Any) {
        cartaoNome.resignFirstResponder()
        cartaoNum.resignFirstResponder()
        cartaoData.resignFirstResponder()
        cartaoCod.resignFirstResponder()
        
        if cartaoNome.text!.isEmpty || cartaoNum.text!.isEmpty || cartaoData.text!.isEmpty || cartaoCod.text!.isEmpty {
            let alerta = UIAlertController(title: "Erro",
                                           message: "Preencha todos os campos",
                                           preferredStyle: UIAlertController.Style.alert)
            
            alerta.addAction(UIAlertAction(title: "OK",
                                           style: UIAlertAction.Style.default,
                                           handler: nil))
            
            present(alerta, animated: true, completion: nil)
            return
        }
        
        self.save(nome: cartaoNome.text!, num: cartaoNum.text!, data: cartaoData.text!, cod: cartaoCod.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func save(nome:String, num:String, data:String, cod:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
          
        let managedContext = appDelegate.persistentContainer.viewContext
        let entidade = NSEntityDescription.entity(forEntityName: "Cartao", in: managedContext)!
        
        if (cartoes != nil){
            let objUpdate = cartoes
            objUpdate?.setValue(nome, forKeyPath: "cartaoNome")
            objUpdate?.setValue(num, forKeyPath: "cartaoNum")
            objUpdate?.setValue(data, forKeyPath: "cartaoData")
            objUpdate?.setValue(cod, forKeyPath: "cartaoCod")
            
        } else {
            let cartao = NSManagedObject(entity: entidade, insertInto: managedContext)
            cartao.setValue(nome, forKeyPath: "cartaoNome")
            cartao.setValue(num, forKeyPath: "cartaoNum")
            cartao.setValue(data, forKeyPath: "cartaoData")
            cartao.setValue(cod, forKey: "cartaoCod")
        }
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
