//
//  NovaVagaViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 26/09/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class NovaVagaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    
    //Endereço
    @IBOutlet weak var txtCep: UITextField!
    @IBOutlet weak var txtRua: UITextField!
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var txtBairro: UITextField!
    @IBOutlet weak var txtCidade: UITextField!
    @IBOutlet weak var txtUF: UITextField!
    @IBOutlet weak var txtComplemento: UITextField!
    
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
        /*
         txtNome.delegate = self
         txtEmail.delegate = self
         txtTelefone.delegate = self
         if (pessoas != nil){
         txtNome.text = pessoas?.value(forKey: "nome")  as? String
         txtTelefone.text = pessoas?.value(forKey: "telefone")  as? String
         txtEmail.text = pessoas?.value(forKey: "email")  as? String
         */
    }        // Do any additional setup after loading the view.
    
    @IBAction func salvar(_sender: Any) {
        /*var freq = ["Segunda-feira":true,
                    "Terça-feira":false,
                    "Quarta-feira":true,
                    "Quinta-feira":false,
                    "Sexta-feira":true,
                    "Sábado":false,
                    "Domingo":false]*/
        
        self.save(
            titulo: txtTitulo.text!,
            descricao: txtDescricao.text!,
            cep: txtCep.text!,
            rua: txtRua.text!,
            numero: txtNumero.text!,
            complemento: txtComplemento.text!,
            bairro: txtBairro.text!,
            cidade: txtCidade.text!,
            uf: txtUF.text!,
            largura: txtLargura.text!,
            comprimento: txtComprimento.text!,
            altura: txtAltura.text!,
            reservado: "false"
        )
        /*
        
        txtNome.resignFirstResponder()
        txtTelefone.resignFirstResponder()
        txtEmail.resignFirstResponder()
        
        if txtNome.text!.isEmpty || txtTelefone.text!.isEmpty || txtEmail.text!.isEmpty{
            let alerta = UIAlertController(
                title: "Erro" ,
                message: "Preencha todos os campos",
                preferredStyle: UIAlertController.Style.alert)
            
            alerta.addAction(UIAlertAction(
                                title: "OK",
                                style: UIAlertAction.Style.default,
                                handler: nil))
            
            present(alerta, animated: true, completion: nil)
            return
        }
        */
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func save(titulo: String, descricao: String, cep: String, rua: String, numero: String, complemento: String, bairro: String, cidade: String, uf: String, largura: String, comprimento: String, altura: String, reservado:String) {
        guard let appDelegate  = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entidade = NSEntityDescription.entity(forEntityName: "Vaga", in: managedContext)!
        let vaga = NSManagedObject(entity: entidade, insertInto: managedContext)
        
        vaga.setValue(titulo, forKeyPath: "titulo")
        vaga.setValue(descricao, forKeyPath: "descricao")
        
        vaga.setValue(cep, forKeyPath: "cep")
        vaga.setValue(rua, forKeyPath: "rua")
        vaga.setValue(numero, forKeyPath: "numero")
        vaga.setValue(complemento, forKeyPath: "complemento")
        vaga.setValue(bairro, forKeyPath: "bairro")
        vaga.setValue(cidade, forKeyPath: "cidade")
        vaga.setValue(uf, forKeyPath: "uf")
        
        vaga.setValue(largura, forKeyPath: "largura")
        vaga.setValue(comprimento, forKeyPath: "comprimento")
        vaga.setValue(altura, forKeyPath: "altura")
        
        vaga.setValue(reservado, forKeyPath: "reservado")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Nao foi possivel salvar \(error), \(error.userInfo)")
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
