//
//  SegundoViewController.swift
//  CollectionView
//
//  Created by dam2 on 18/12/23.
//

import UIKit

class SegundoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var especie: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var genero: UILabel!
    @IBOutlet weak var origen: UILabel!
    @IBOutlet weak var localizacion: UILabel!
    
    @IBOutlet weak var episodios: UITableView!
    
    var character: CharacterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodios.delegate = self
        episodios.dataSource = self
        
        update()
    }
    
    func update() {
        guard let character = character else { return }
        
        nombre.text = character.name
        especie.text = character.species
        estado.text = character.status
        genero.text = character.gender
        origen.text = character.origin.name
        localizacion.text = character.location.name

        let imageUrl = URL(string: character.image)
        
        let dataTask = URLSession.shared.dataTask(with: imageUrl!) { (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self.imagen.image = UIImage(data: data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character?.episode.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodes", for: indexPath)
        
        cell.textLabel?.text = character?.episode[indexPath.row] ?? ""
        
        return cell
    }
}
