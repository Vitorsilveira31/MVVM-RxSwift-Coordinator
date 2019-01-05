//
//  ServiceResult.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 23/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

enum ServiceResult<T> {
    case success(result: T)
    case error(error: RequestError)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .error:
            return false
        }
    }
    
    var item: T? {
        switch self {
        case .success(let result):
            return result
        default:
            return nil
        }
    }
    
    var error: RequestError {
        switch self {
        case .error(let error):
            return error
        default:
            return RequestError.cancelled
        }
    }
}
