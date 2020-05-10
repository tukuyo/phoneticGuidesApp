//
//  OutputViewController.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/10.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class OutputViewController: UIViewController {
    
    let outputTextView = UITextView().then {
        $0.backgroundColor = UIColor(named: "textView")
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(named: "border")?.cgColor
        $0.layer.borderWidth = 3
        $0.text = "変換に失敗した"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let dismissButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "buttonBody")
        $0.setTitle("変換", for: .normal)
        $0.setTitleColor(UIColor(named: "buttonString"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var outputViewModel: OutputViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        initializeViewModel()
        bindViewModel()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let pt = previousTraitCollection else { return }
        if #available(iOS 13.0, *) {
            if pt.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
                outputTextView.layer.borderColor = UIColor(named: "border")?.cgColor
            }
        }
    }
    
    func initializeUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(outputTextView)
        setUpLayout()
    }
    
    func initializeViewModel() {
        guard outputViewModel == nil else { return }
        outputViewModel = OutputViewModel()
    }
    
    func setUpLayout() {
        outputTextView.snp.makeConstraints{
            $0.top.bottom.width.equalTo(view.safeAreaLayoutGuide).inset(20)
            
            $0.centerX.equalTo(view)
        }
    }
    
    func bindViewModel() {
        let input = OutputViewModel.Input(dismissTrigger: dismissButton.rx.tap.asDriver())
        let output = outputViewModel.transform(input: input)
        output.convertedText.map { $0?.converted }.drive(outputTextView.rx.text).disposed(by: disposeBag)
    }
    
    
}
