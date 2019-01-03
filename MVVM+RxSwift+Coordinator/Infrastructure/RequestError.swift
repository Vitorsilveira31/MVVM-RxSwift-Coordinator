//
//  RequestError.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 26/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

public enum RequestError: Error {
    case httpError(Int, Data?)
    case parse(String)
    case requestError(String)
    case timeoutError
    case cancelled
    case sessionExpired
    case unexpected
    
    public var message: String {
        switch self {
        case .httpError(let code, _):
            return "Erro HTTP com o código - \(code)"
        case .parse(let error):
            return error
        case .requestError(let error):
            return error
        case .timeoutError:
            return "Erro de timeout"
        case .cancelled:
            return "Requisição cancelada"
        case .sessionExpired:
            return "Sessão expirada"
        case .unexpected:
            return "Error inesperado"
        }
    }
    
    public var title: String {
        switch self {
        case .httpError:
            return "HTTP Error"
        case .parse:
            return "Parse"
        case .requestError:
            return "Request Error"
        case .timeoutError:
            return "Timeout"
        case .cancelled:
            return "Cancelled"
        case .sessionExpired:
            return "Session Expired"
        case .unexpected:
            return "Unexpected"
        }
    }
}
