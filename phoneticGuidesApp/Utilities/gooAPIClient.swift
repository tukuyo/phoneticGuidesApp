//
//  gooAPIClient.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/10.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import Foundation
import Alamofire

protocol APIClient {
    var URL: String { get }
    func postRequest(_ parameters: [String: String]) -> DataRequest
}

class gooAPIClient: APIClient{
    // エンドポイント
    let URL: String = "https://labs.goo.ne.jp/api/hiragana"
    
    // gooAPIClientに対してポストリクエストを送る関数
    func postRequest(_ parameters: [String: String]) -> DataRequest {
        return AF.request(URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }
}
