//
//  ViewController.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/08.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import UIKit
import Then

import Alamofire

class ViewController: UIViewController {
    
    let convertButton = UIButton().then {
        $0.frame = CGRect(x: 100, y: 100, width: 50, height: 20)
        $0.backgroundColor = .blue
        $0.setTitle("push", for: .normal)
        $0.addTarget(self, action: #selector(pushConvert), for: .touchUpInside)
    }
    
    let textLabel = UILabel().then {
        $0.frame = CGRect(x: 100, y: 200, width: 500, height: 200)
        $0.text = "NO"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(convertButton)
    }
    
    @objc func pushConvert() {
        print("AAA")
        var testString = "無闇に字面を飾り、ことさらに漢字を避けたり、不要の風景の描写をしたり、みだりに花の名を記したりする事は厳に慎しみ、ただ実直に、印象の正確を期する事一つに努力してみて下さい。君には未だ、君自身の印象というものが無いようにさえ見える"
        testString = "アイウエオ"
        let testMultiLineString = """
                                  無闇に字面を飾り、ことさらに漢字を避けたり、
                                  不要の風景の描写をしたり、みだりに花の名を記したりする事は厳に慎しみ、
                                  ただ実直に、印象の正確を期する事一つに努力してみて下さい。
                                  君には未だ、君自身の印象というものが無いようにさえ見える
                                  """
        
        
        let url = "https://labs.goo.ne.jp/api/hiragana"
        let headers: HTTPHeaders = [
            
        ]
        let parameters = [
            "app_id": API_KEY,
            "request_id": "0",
            "sentence": testMultiLineString,
            "output_type": "hiragana"
        ]
        
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                do {
                    let resultText: ConvertText = try JSONDecoder().decode(ConvertText.self,from: data)
                    print(resultText)
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}

