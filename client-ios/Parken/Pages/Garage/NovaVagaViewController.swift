//
//  NovaVagaViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 26/09/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class NovaVagaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var txtPreco: UITextField!
    
    //Endereço
    @IBOutlet weak var txtCep: UITextField!
    @IBOutlet weak var txtRua: UITextField!
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var txtComplemento: UITextField!
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
    
    private var geoCoder: CLGeocoder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoCoder = CLGeocoder()
        
        txtCep.keyboardType = .numberPad
        txtPreco.keyboardType = .decimalPad
        txtNumero.keyboardType = .numberPad
        txtLargura.keyboardType = .decimalPad
        txtComprimento.keyboardType = .decimalPad
        txtAltura.keyboardType = .decimalPad
    }        // Do any additional setup after loading the view.
    
    @IBAction func salvar(_sender: Any) {
        let id:String = "\(txtRua.text!), \(txtNumero.text!), \(txtCep.text!), \(txtTitulo.text!)"
        
        let preco:Double = Double(txtPreco.text!)!
        
        let freq:Dictionary = ["Segunda-feira":switchSegunda.isOn,
                    "Terça-feira":switchTerca.isOn,
                    "Quarta-feira":switchQuarta.isOn,
                    "Quinta-feira":switchQuinta.isOn,
                    "Sexta-feira":switchSexta.isOn,
                    "Sábado":switchSabado.isOn,
                    "Domingo":switchDomingo.isOn]
        
        let endereco:String = "\(txtRua.text!), \(txtNumero.text!), \(txtBairro.text!), \(txtCidade.text!)"
        
        geoCoder!.geocodeAddressString(endereco) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    self.showDialog(title: "Erro", message: "Não foi possível obter coordenadas dessa localização")
                    return
            }
                        
            self.save(
                id: id,
                titulo: self.txtTitulo.text!,
                descricao: self.txtDescricao.text!,
                custo: preco,
                cep: self.txtCep.text!,
                rua: self.txtRua.text!,
                numero: self.txtNumero.text!,
                complemento: self.txtComplemento.text!,
                bairro: self.txtBairro.text!,
                cidade: self.txtCidade.text!,
                uf: self.txtUF.text!,
                largura: self.txtLargura.text!,
                comprimento: self.txtComprimento.text!,
                altura: self.txtAltura.text!,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                //reservado: "false",
                frequencia: freq)
            
             self.navigationController?.popViewController(animated: true)
        }
        /*
        TODO validar campos
         
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
    }
    
    func save(
        id: String,
        titulo: String,
        descricao: String,
        custo:Double,
        cep: String,
        rua: String,
        numero: String,
        complemento: String,
        bairro: String,
        cidade: String,
        uf: String,
        largura: String,
        comprimento: String,
        altura: String,
        latitude: Double,
        longitude: Double,
        //reservado:String,
        frequencia:Dictionary<String,Any>) {
        guard let appDelegate  = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entidade = NSEntityDescription.entity(forEntityName: "Vaga", in: managedContext)!
        let vaga = NSManagedObject(entity: entidade, insertInto: managedContext)
        
        vaga.setValue(id, forKey: "id")
        vaga.setValue(titulo, forKeyPath: "titulo")
        vaga.setValue(descricao, forKeyPath: "descricao")
        vaga.setValue(custo, forKeyPath: "valor")
        
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
        
        vaga.setValue(latitude, forKeyPath: "latitude")
        vaga.setValue(longitude, forKeyPath: "longitude")
        
        //vaga.setValue(reservado, forKeyPath: "reservado")
        
        for (dia, status) in frequencia {
            print("\n\n\nPara o dia '\(dia)', o status é '\(status)'.\n")
        }
        
        vaga.setValue(frequencia, forKey: "frequencia")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Nao foi possivel salvar \(error), \(error.userInfo)")
        }
    }
     
     private func showDialog(title: String, message: String) {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         present(alertController, animated: true, completion: nil)
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
