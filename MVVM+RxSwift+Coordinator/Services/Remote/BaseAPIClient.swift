//
//  BaseAPIClient.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 26/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class BaseAPIClient {
    
    private let disposeBag = DisposeBag()
    
    public func requestWithCodableResponse<P: TargetType, T: Decodable>(_ targetType: P, completion: @escaping (ServiceResult<T>) -> Void) {
        let provider = MoyaProvider<P>()
        provider.rx.request(targetType)
            .filterSuccessfulStatusCodes()
            .map(T.self)
            .subscribe(onSuccess: {
                completion(ServiceResult.success(result: $0))
            }, onError: {
                guard let error = $0 as? MoyaError else {
                    completion(ServiceResult.error(error: RequestError.unexpected))
                    return
                }
                completion(ServiceResult.error(error: self.handleMoyaError(error)))
            }).disposed(by: disposeBag)
    }
    
    public func requestWithJsonResponse<P: TargetType, T>(_ targetType: P, completion: @escaping (ServiceResult<T>) -> Void) {
        let provider = MoyaProvider<P>()
        provider.rx.request(targetType)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .subscribe(onSuccess: {
                guard let response = $0 as? T else {
                    completion(ServiceResult.error(error: RequestError.parse("Erro ao mapear o JSON.")))
                    return
                }
                completion(ServiceResult.success(result: response))
            }, onError: {
                guard let error = $0 as? MoyaError else {
                    completion(ServiceResult.error(error: RequestError.unexpected))
                    return
                }
                completion(ServiceResult.error(error: self.handleMoyaError(error)))
            }).disposed(by: disposeBag)
    }
    
    private func handleMoyaError(_ moyaError: MoyaError) -> RequestError {
        switch moyaError {
        case .imageMapping(_ ):
            return RequestError.parse("Erro ao mapear a imagem.")
        case .jsonMapping(_ ):
            return RequestError.parse("Erro ao mapear o JSON.")
        case .stringMapping(_ ):
            return RequestError.parse("Erro ao mapear uma String.")
        case .objectMapping(_, _ ):
            return RequestError.parse("Erro ao mappear o Objeto.")
        case .encodableMapping(_ ):
            return RequestError.parse("Erro ao mappear um Objeto Codable.")
        case .statusCode(let response):
            return RequestError.httpError(response.statusCode, response.data)
        case .underlying(_, _):
            return RequestError.unexpected
        case .requestMapping(let messageError):
            return RequestError.requestError(messageError)
        case .parameterEncoding(let error):
            return RequestError.requestError(error.localizedDescription)
        }
    }
    
    
}
