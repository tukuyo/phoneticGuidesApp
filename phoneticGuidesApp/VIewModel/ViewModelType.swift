//
//  ViewModel.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/10.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype State
    
    func transform(input: Input) -> Output
}
