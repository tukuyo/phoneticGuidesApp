//
//  gooAPIClient.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/09.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import Foundation
import Alamofire

struct ConvertText: Codable {
    var request_id: String
    var output_type: String
    var converted: String
}
