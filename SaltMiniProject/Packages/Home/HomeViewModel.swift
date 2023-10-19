//
//  HomeViewModel.swift
//  SaltMiniProject
//
//  Created by Aditya Ramadhan on 19/10/23.
//

import Foundation
import RxSwift

enum HomeState {
    case loading
    case loaded
}

class HomeViewModel {
    
    var apiService = APIService.shared
    
    private var userItems = PublishSubject<[UserItem]>()
    var userItemsObservable: RxSwift.Observable<[UserItem]> {
        return userItems.asObservable()
    }
    
    func getUserDetails() {
        self.apiService.getDetailUsers(page: 2) { result in
            switch result {
            case .success(let response):
                self.userItems.onNext(response.data)
            case .failure(let err):
                print("err", err)
            }
        }
    }
}
