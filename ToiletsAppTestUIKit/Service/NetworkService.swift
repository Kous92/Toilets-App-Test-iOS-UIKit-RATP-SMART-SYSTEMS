//
//  NetworkService.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 16/10/2022.
//

import Foundation

final class NetworkService: APIService {
    func fetch<T: Codable>(completion: @escaping (Result<T, APIError>) -> ()) {
        guard let url = URL(string: "https://data.ratp.fr/api/records/1.0/search/?dataset=sanisettesparis2011&start=0&rows=100") else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("URL appelée: \(url.absoluteString)")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Erreur réseau
            guard error == nil else {
                print(error?.localizedDescription ?? "Erreur réseau")
                completion(.failure(.networkError))
                
                return
            }
            
            // Pas de réponse du serveur
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                
                return
            }
            
            print("Code HTTP: \(httpResponse.statusCode)")
            switch httpResponse.statusCode {
                // Code 200, vérifions si les données existent
                case (200...299):
                    if let data = data {
                        var output: T?
                        
                        do {
                            output = try JSONDecoder().decode(T.self, from: data)
                        } catch {
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        if let output {
                            completion(.success(output))
                        }
                    } else {
                        completion(.failure(.decodeError))
                    }
                default:
                completion(.failure(.networkError))
            }
        }
        task.resume()
    }
}
