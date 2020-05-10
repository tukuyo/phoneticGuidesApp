//
//  gooConvertAPIMode.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/10.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class gooConvertAPIModel {
    
    let client = gooAPIClient()
    // 必要なパラメータ
    var parameters = [
        "app_id": API_KEY,
        "request_id": "0"
    ]
    
    func convertText(_ text: String, type: String = "hiragana") -> Observable<Result> {
        setParameter(text: text, type: type, date: Date())
        return Observable<Result>.create { (observer) -> Disposable in
            let request = self.client.postRequest(self.parameters).responseJSON{ response in
                if let error = response.error {
                    observer.onError(error)
                }
                let result = self.parseJSON(response.data ?? [])
                
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    // 戻り値をCodableでResult型に整形
    private func parseJSON(_ json: Any) -> Result {
        // 戻り値、変換後の結果
        var convertedText = Result()
        guard let data = json as? Data else { return convertedText}
        
        do {
            convertedText = try JSONDecoder().decode(Result.self, from: data)
        } catch {
            print(error)
        }
        //空白削除
        convertedText.converted = convertedText.converted.components(separatedBy: CharacterSet.whitespaces).joined()
        return convertedText
    }
    
    //パラメータをセットする関数
    private func setParameter(text: String, type: String, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = formatter.string(from: date)
        
        parameters["output_type"] = type
        parameters["sentence"]    = text
        parameters["request_id"]  = strDate + "-tukuyo"
    }
    
    
}
