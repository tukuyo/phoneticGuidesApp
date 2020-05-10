//
//  ConvertModel.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/09.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import Foundation
import Alamofire

// 変換後の値が入る構造体
struct Result: Codable {
    var request_id: String
    var output_type: String
    var converted: String
    
    init() {
        request_id = "0"
        output_type = "none"
        converted = "変換できませんでした．"
    }
}
