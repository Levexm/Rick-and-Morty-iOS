//
//  ViewController.swift
//  CollectionView
//
//  Created by dam2 on 14/12/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var personajes = [CharacterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.downloadData()
    }
    
    func downloadData(){
        let urlString = "https://rickandmortyapi.com/api/character"
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                print(response)
            }
            
            guard let data = data else { return }
            
            do {
                let personajes = try JSONDecoder().decode(CharacterResponse.self, from: data)
                self.personajes = personajes.results
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Se ha producido un error: \(error)")
            }
        }.resume()
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "SegundoVC") as? SegundoViewController {
            vc.character = personajes[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        
        var celdaWidth = 0
        
        if screenWidth > 700 {
            celdaWidth = Int(screenWidth / 5 - 12)
        } else {
            celdaWidth = Int(screenWidth / 2 - 8)
        }
        
        return CGSize(width: celdaWidth, height: celdaWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        personajes.count
        
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! MiCelda
        
        cell.miNombre.text = personajes[indexPath.item].name
        cell.miEspecie.text = personajes[indexPath.item].species
        
        let imageUrl = URL(string: personajes[indexPath.item].image)
        
        let dataTask = URLSession.shared.dataTask(with: imageUrl!) { (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.miImagen.image = UIImage(data: data)
                }
            }
        }
        
        dataTask.resume()
        
        return cell
    }
}
