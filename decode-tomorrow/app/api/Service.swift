//
//  Service.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import Moya

enum Service {
    case login(LoginParams)
    case register(RegistrationParams)
    case getTasksList
}

extension Service: TargetType {
    
    var baseURL: URL {
        let urlString = "www.foo.ph/api/"
        guard let url = URL(string: urlString) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        case .getTasksList:
            return "tasks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
             .register:
            return .post
        case .getTasksList:
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let params):
            return .requestJSONEncodable(params)
        case .register(let params):
            return .requestJSONEncodable(params)
        case .getTasksList:
            return .requestPlain
        }
    }
    
    enum AuthType {
        case none
        case loggedIn
    }
    
    var headers: [String : String]? {
        switch self.authType {
        case .none:
            return nil
        case .loggedIn:
            return [HeaderKeys.authorization.rawValue: CredentialsManager.shared.token!]
        }
    }
    
}

// MARK: - Custom

extension Service {
    
    var authType: AuthType {
        switch self {
        case .register,
             .login:
            return .none
        case .getTasksList:
            return .loggedIn
        }
    }
    
}