//
//  RegisterViewModel.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import Foundation
import RxSwift

enum RegisterState {
    case invalidEmail
    case loading
    case loaded
    case error(message:String)
}

class RegisterViewModel {
    
    var apiService = APIService.shared
    
    private var token = PublishSubject<AuthReturnParam>()
    var tokenObservable: RxSwift.Observable<AuthReturnParam> {
        return token.asObservable()
    }
    
    private var state = PublishSubject<RegisterState>()
    var stateObservable: RxSwift.Observable<RegisterState> {
        return state.asObservable()
    }
    
    func login(email: String, password: String) {
        self.state.onNext(.loading)
        if isValidEmail(email: email) {
            self.apiService.login(email: email, password: password) { result in
                switch result {
                case .success(let response):
                    self.state.onNext(.loaded)
                    self.token.onNext(response)
                case .failure(let err):
                    self.state.onNext(.loaded)
                    print("err", err)
                }
            }
        } else {
            self.state.onNext(.invalidEmail)
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
