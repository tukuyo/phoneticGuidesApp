//
//  OutputViewModel.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/10.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OutputViewModel: ViewModelType {
    
    struct Input {
        let dismissTrigger: Driver<Void>
    }
    
    struct Output {
        let copy: Driver<Void>
        let convertedText: Driver<Result?>
        let error: Driver<Error>
    }
    
    struct State {
        let error = ErrorTracker()
    }
    
    private let convertedText: Result?
    
    init(with convertedText: Result? = nil) {
        self.convertedText = convertedText
    }
    
    func transform(input: OutputViewModel.Input) -> OutputViewModel.Output {
        let state = State()
        let copy = input.dismissTrigger.do(onNext: { [unowned self] in
            if self.convertedText?.converted == "変換できませんでした．" {
                return  // ここでエラーを返したい．
            }
            UIPasteboard.general.string = self.convertedText?.converted
        })
        return OutputViewModel.Output(copy: copy,
                                      convertedText: Driver.just(convertedText),
                                      error: state.error.asDriver())
    }
    
}
