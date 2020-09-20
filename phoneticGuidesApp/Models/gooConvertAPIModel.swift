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
import Alamofire

class gooConvertAPIModel {
    
    // API Client
    let client = gooAPIClient()
    // 必要なパラメータ
    var parameters = [
        "app_id": API_KEY,
        "request_id": "0"
    ]
    
    // テキストを変換する
    func convertText(_ text: String, type: String = "hiragana") -> Observable<Result> {
        setParameter(text: text, type: type, date: Date())
        return Observable<Result>.create { [weak self] (observer) -> Disposable in
            let request = self?.client.postRequest(self!.parameters).responseJSON{ response in
                
                switch response.result {
                    // リクエスト成功時
                    case .success(let value):
                        if let result = self?.parseJSON(value) {
                            observer.onNext(result)
                            observer.onCompleted()
                        } else {
                            let error = self?.openError(value)
                            observer.onError(Exception.generic(message: error!))
                        }
                    // リクエスト失敗時
                    case .failure(let error):
                        observer.onError(error)
                }
            }
            return Disposables.create { request?.cancel() }
        }
    }
    
    // エラーメッセージをきれいに整える
    private func openError(_ json: Any) -> String {
        guard let error = json as? [String:Any] else { return "" }
        guard let description = error["error"] as? [String: Any] else { return "" }
        
        let convertDescription = self.convertDescription(description["message"] as! String)
        return convertDescription
    }
    
    // 英語のメッセージを日本語に変換する
    private func convertDescription(_ description: String) -> String {
        switch description {
        case "Invalid request parameter":
            return "テキストを入力してください．"
        case "Invalid app_id":
            return "API キーが不正です．"
        case "Suspended app_id":
            return "APIキーが凍結されています．"
        default:
            return "判別不能のエラーです．"
        }
    }
    
    // 戻り値をCodableでResult型に整形
    private func parseJSON(_ json: Any) -> Result? {
        // 戻り値、変換後の結果
        var convertedText = Result()
        guard let data = json as? [String: String] else { return nil }
        guard let jsonData = try? JSONSerialization.data(withJSONObject:data) else { return nil }
        do {
            convertedText = try JSONDecoder().decode(Result.self, from: jsonData)
        } catch {
            return nil
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
