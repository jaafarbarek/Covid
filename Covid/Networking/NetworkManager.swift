//
//  NetworkManager.swift
//  Jini
//
//  Created by Apple on 6/20/18.
//  Copyright © 2018 Jaafar Barek. All rights reserved.
//

import Foundation

enum NetworkStatus: Int{
    
    case failed = 0, success = 1, tokenExpired = 2,noConnection = 3
    
}
enum RequestType:String {
    case post = "POST" ,  get = "GET" ,  delete = "DELETE" ,  put = "PUT"
    
}
