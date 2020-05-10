//
//  InputViewModel.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/09.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class InputViewModel: ViewModelType {
    
    //　ビューにあるボタンとテキストビュー
    struct Input {
        let convertTrigger: Driver<Void>
        let text: Driver<String>
    }
    
    //
    struct Output {
        let convertedText: Driver<Result>
        let error: Driver<Error>
    }
    
    //
    struct State {
        let error = ErrorTracker()
    }
    
    private let apiModel: gooConvertAPIModel
    
    init(with APIModel: gooConvertAPIModel) {
        self.apiModel = APIModel
    }
    
    
    func transform(input: InputViewModel.Input) -> InputViewModel.Output {
        let state = State()
        let converted = input.convertTrigger
            .withLatestFrom(input.text)
            .flatMapLatest { [unowned self] content in
                return self.apiModel.convertText(content)
                    .trackError(state.error)
                    .asDriverOnErrorJustComplete()
            }
        return InputViewModel.Output(convertedText: converted, error: state.error.asDriver())
    }
    
}
