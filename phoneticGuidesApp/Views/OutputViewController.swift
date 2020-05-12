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
import Toast_Swift
import RxSwift
import RxCocoa

class OutputViewController: UIViewController {
    
    // 変換後のテキストを表示する．
    let outputTextView = UITextView().then {
        $0.backgroundColor = UIColor(named: "textView")
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(named: "border")?.cgColor
        $0.layer.borderWidth = 3
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.isEditable = false
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // クリップボードにコピーするボタン．
    let copyButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "buttonBody")
        $0.setTitle("Copy", for: .normal)
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
    
    // ライト・ダークモード切り替え対応
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let pt = previousTraitCollection else { return }
        if #available(iOS 13.0, *) {
            if pt.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
                outputTextView.layer.borderColor = UIColor(named: "border")?.cgColor
            }
        }
    }
    
    // UI初期化
    func initializeUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(outputTextView)
        view.addSubview(copyButton)
        setUpLayout()
    }
    
    // ViewModelの初期化
    // NOTE: 必ずこのビューに来る際には、outputViewModelが渡されるので必要がない気がするが...
    func initializeViewModel() {
        guard outputViewModel == nil else { return }
        outputViewModel = OutputViewModel()
    }
    
    // Layout
    func setUpLayout() {
        outputTextView.snp.makeConstraints{
            $0.top.width.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(copyButton.snp.top).inset(-20)
            $0.centerX.equalTo(view)
        }
        copyButton.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            $0.height.equalTo(50)
            $0.centerX.equalTo(view)
        }
    }
    
    // ボタンとテキストのバインド
    func bindViewModel() {
        let input = OutputViewModel.Input(dismissTrigger: copyButton.rx.tap.asDriver())
        let output = outputViewModel.transform(input: input)
        output.convertedText.map { $0?.converted }.drive(outputTextView.rx.text).disposed(by: disposeBag)
        output.copy.drive(onNext:showCopyAlert).disposed(by: disposeBag)
        
    }
    
    // トーストの表示
    func showCopyAlert() {
        self.view.makeToast("コピーしました!!")
    }
}
