//
//  NetworkService.swift
//  ROUGH API2
//
//  Created by mac on 6/4/21.
//

import UIKit

class NetworkService {
    static let instance = NetworkService()
    private init() { }
    let factBaseUrl = "https://cat-fact.herokuapp.com"
    let catApiBaseUrl = "https://api.thecatapi.com"
    
    func makeFactRequest(completion: @escaping (String) -> ()) {
        
        let randomFactEndpoint = URL(string: "\(factBaseUrl)/facts/random" )
        guard let url = randomFactEndpoint else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{
                debugPrint("Server error")
                return
            }
            
            guard let data = data else{return}
            
            do{
              
               guard let json = try JSONSerialization.jsonObject(with: data, options:
                                        // we treat the data as a dictionary which means we will filter through out result using key-value pair
                 [.allowFragments]) as? [String:Any] else{return}
               let fact = json["text"] as? String ?? ""
                DispatchQueue.main.async {
                   completion(fact)
                }
               
             
              }catch{
                  debugPrint("Error returning data for images")
              }
       
        }
        task.resume()
    }
    
    func downloadCatImage(completion: @escaping (UIImage, String) -> ()) {
        
        getCatImageUrl { url in
            self.downloadImage(url: url) { image in
                completion(image, url)
            }
        }
    }
    
    
    
    func getCatImageUrl(completion: @escaping (String) -> ()) {
        
        let randomFactEndpoint = URL(string: "\(catApiBaseUrl)/v1/images/search")
        guard let url = randomFactEndpoint else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{
                debugPrint("Server error")
                return
            }
            
            guard let data = data else{return}
            
            do{
              
               guard let json = try JSONSerialization.jsonObject(with: data, options:
                                        // we treat the data as a dictionary which means we will filter through out result using key-value pair
                 [.allowFragments]) as? [[String:Any]] else{return}
               let imageUrl = json[0]["url"] as? String ?? ""
               completion(imageUrl)
            
              }catch{
                  debugPrint("Error returning data for images")
              }
       
        }
        task.resume()
    }
    
    
    
    func downloadImage(url: String, completion: @escaping (UIImage) -> ()) {
        
        
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{
                debugPrint("Server error")
                return
            }
            
            guard let data = data else{return}
            
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                completion(image)
            }
            
            
        }
        task.resume()
    }
    
    
    
    func getCatBreeds(completion: @escaping([String]) -> ())  {
        
        guard let url = URL(string: "\(catApiBaseUrl)/v1/breeds") else {return}
        let apikey = "1b01e45a-ab7d-476e-a83d-557f2a25180d"
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(apikey, forHTTPHeaderField: "x-api-key")
        
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{
                debugPrint("Server error")
                return
            }
            
            guard let data = data else{ return}
          
            
            do {
               
                guard let breeds = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [[String: Any]] else {return}
              
                var catBreeds = [String]()
                
                for cat in breeds {
                    let name = cat["name"] as? String ?? "No name found"
                    catBreeds.append(name)
                }
               
                completion(catBreeds)
               
            } catch{
                debugPrint("JSON error: \(error.localizedDescription)")
            }
            
          
        
        }
        
        task.resume()

    
    }
    
    func getCatImageTags(imgUrl: String, completion: @escaping([ClarifaiCat]) -> ()) {
        guard let url = URL(string: "https://api.clarifai.com/v2/models/aaa03c23b3724a16a56b629203edc62c/outputs") else {return}
        let apikey = "Key 1e66123a418f492abe82f39115e049d2"
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(apikey, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let json: [String: Any] =  [
            
            "inputs": [
                [
                "data": [
                    "image": [
                        "url": imgUrl
                    ]
                ]
            ]
        ]
            
    ]
      
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        urlRequest.httpBody = jsonData
        
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{
                debugPrint("Server error")
                return
            }
            
            guard let data = data else{ return}
          
            
            do {
               
                guard let clarifaiData = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {return}
              
                guard let outputs = clarifaiData["outputs"] as? [[String: Any]] else{return}
                guard let outputsData = outputs[0]["data"] as? [String: Any] else{return}
                guard let concepts = outputsData["concepts"] as? [[String: Any]] else{return}
                
                var clarifaiCats = [ClarifaiCat]()
                
                for concept in concepts {
                    
                    let name = concept["name"] as? String ?? ""
                    let certainty = concept["value"] as? CGFloat ?? 0.0
                    
                    let newCat = ClarifaiCat(name: name, probability: certainty)
                    clarifaiCats.append(newCat)
                    DispatchQueue.main.async {
                        completion(clarifaiCats)
                    }
                    
                }
               
               
               
            } catch{
                debugPrint("JSON error: \(error.localizedDescription)")
            }
            
          
        
        }
        
        task.resume()
    }
    
    
    
    
    
    
    
    
    
}
