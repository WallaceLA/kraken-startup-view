//
//  AtualizarFrequenciaViewController.swift
//  Parken
//
//  Created by Wallace Aguiar on 05/10/20.
//  Copyright © 2020 Julio Avila. All rights reserved.
//

import UIKit
import CoreData

class AtualizarFrequenciaViewController: UIViewController {

    var vaga:NSManagedObject? = nil
    
    @IBOutlet weak var segunda: UISwitch!
    @IBOutlet weak var terca: UISwitch!
    @IBOutlet weak var quarta: UISwitch!
    @IBOutlet weak var quinta: UISwitch!
    @IBOutlet weak var sexta: UISwitch!
    @IBOutlet weak var sabado: UISwitch!    
    @IBOutlet weak var domingo: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(vaga != nil){
            let freq = vaga!.value(forKeyPath: "frequencia") as! Dictionary<String, Bool>
           
            segunda.isOn = freq["Segunda-feira"]!
            terca.isOn = freq["Terça-feira"]!
            quarta.isOn = freq["Quarta-feira"]!
            quinta.isOn = freq["Quinta-feira"]!
            sexta.isOn = freq["Sexta-feira"]!
            sabado.isOn = freq["Sábado"]!
            domingo.isOn = freq["Domingo"]!
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmar(_ sender: Any) {
        
        let freqUpdate:Dictionary = ["Segunda-feira":segunda.isOn,
        "Terça-feira":terca.isOn,
        "Quarta-feira":quarta.isOn,
        "Quinta-feira":quinta.isOn,
        "Sexta-feira":sexta.isOn,
        "Sábado":sabado.isOn,
        "Domingo":domingo.isOn]
        
        print(freqUpdate)
        
        self.save(frequencia: freqUpdate)
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func save(frequencia:Dictionary<String, Bool>){
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
           let managedContext = appDelegate.persistentContainer.viewContext
                      
           if (vaga != nil){
               let objectUpdate = vaga
               objectUpdate?.setValue(frequencia, forKeyPath: "frequencia")
               
           }else{
               print("ERRO! Vaga nula!")
           }
           
           do {
               try managedContext.save()
           } catch let error as NSError {
               print("Não foi possível salvar \(error), \(error.userInfo)")
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
