//
//  ApiRequest.swift
//  RentaTeam
//
//  Created by Flash Jessi on 11/9/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation
import UIKit

class ApiRequest {
    static let shared = ApiRequest()
    private let appKey = "267e1d2e3e6ccff9a44b6bdae269b3b4"
    private let secret = "58a1cd070bbe192e41668cbd46946bf6"

    public func getImage(code: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlImage = URL(string: "https://http.cat/\(code)") else {
            print("Error: Wrong mage url.")
            completion(.failure(ApiError.noData))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: urlImage) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    print("Error: Image not found")
                    completion(.failure(ApiError.noData))
                    return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
