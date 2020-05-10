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
        let convertedText: Driver<Result?>
    }
    
    struct State {
        let error = ErrorTracker()
    }
    
    private let convertedText: Result?
    
    init(with convertedText: Result? = nil) {
        self.convertedText = convertedText
    }
    
    func transform(input: OutputViewModel.Input) -> OutputViewModel.Output {
        return OutputViewModel.Output(convertedText: Driver.just(convertedText))
    }
    
}
