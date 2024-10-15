//
//  WifiConnectErrors.swift
//  Wasap
//
//  Created by 김상준 on 10/10/24.
//

enum WiFiConnectionErrors: Error {
    case failedToConnect(String)
    case invalidPassword(String)
    case alreadyConnected(String)
    
    var localizedDescription: String {
        switch self {
        case .failedToConnect(let ssid):
            return "Failed to connect to \(ssid)"
        case .invalidPassword(let ssid):
            return "SSID 나 비밀번호가 형식에 맞지 않습니다: \(ssid)"
        case .alreadyConnected(let ssid):
            return "이미 \(ssid)에 연결되어 있습니다."
        }
        
        
    }
    
}

