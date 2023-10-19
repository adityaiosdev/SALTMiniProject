//
//  APIService.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    var baseURL = "https://reqres.in/"
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<AuthReturnParam, Error>) ->()
    ) {
        let apiUrl = baseURL + "api/login"
        let params: [String: Any] = [
            "email": email,
            "password": password
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        AF.request(apiUrl, method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: headers)
            .responseDecodable(of: AuthReturnParam.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
    
    func getDetailUsers(
        page: Int,
        completion: @escaping (Result<ResponseContract, Error>) -> ()
    ) {
        let apiUrl = baseURL + "api/users"
        let params: [String: Any] = [
            "page" : page
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(apiUrl, method: .get, parameters: params, headers: headers)
            .responseDecodable(of: ResponseContract.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
    }
}
