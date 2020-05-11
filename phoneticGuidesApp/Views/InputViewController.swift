//
//  ViewController.swift
//  phoneticGuidesApp
//
//  Created by Yoshio on 2020/05/08.
//  Copyright © 2020 tukuyo. All rights reserved.
//

import UIKit
import Then
import SnapKit
import KMPlaceholderTextView
import RxSwift
import RxCocoa

class InputViewController: UIViewController {
    
    let convertButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "buttonBody")
        $0.setTitle("変換", for: .normal)
        $0.setTitleColor(UIColor(named: "buttonString"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 変換する前の文章
    let inputTextView = KMPlaceholderTextView().then {
        $0.placeholder = "ここにふりがな(ルビ)に変換したいテキストを入力してください．"
        $0.placeholderColor = UIColor(named: "placeholder")!
        $0.placeholderFont = UIFont.systemFont(ofSize: 20)
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.backgroundColor = UIColor(named: "textView")
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(named: "border")?.cgColor
        $0.layer.borderWidth = 3
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var inputViewModel: InputViewModel!
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
                inputTextView.layer.borderColor = UIColor(named: "border")?.cgColor
            }
        }
    }
    
    
    func initializeUI() {
        self.title = "ふりがなを生成"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        inputTextView.delegate = self
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(convertButton)
        view.addSubview(inputTextView)
        setUpLayout()
    }
    
    func initializeViewModel() {
        inputViewModel = InputViewModel(
            with: gooConvertAPIModel())
    }
    
    func setUpLayout() {
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalTo(view)
        }
        
        convertButton.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
            $0.top.equalTo(inputTextView.snp.bottom).inset(-10)
            $0.centerX.equalTo(view)
        }
    }
    
    func bindViewModel() {
        let input = InputViewModel.Input(convertTrigger: convertButton.rx.tap.asDriver(),
                                         text: inputTextView.rx.text
                                            .map{ if let t = $0 { return t } else { return "" } }
                                            .asDriver(onErrorJustReturn: ""))
        let output = inputViewModel.transform(input: input)
        output.convertedText.drive(onNext: willShow).disposed(by: disposeBag)
    }
    
    // どうの方法でコードベースで遷移先に飛ばせば良いのか？
    func willShow(result: Result) {
        let vc = OutputViewController()
        vc.outputViewModel = OutputViewModel(with: result)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension InputViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.inputTextView.isFirstResponder) {
            self.inputTextView.resignFirstResponder()
        }
    }
}
