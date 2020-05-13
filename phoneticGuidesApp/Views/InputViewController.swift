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
import AwesomeSpotlightView
import CDAlertView
import RxSwift
import RxCocoa

class InputViewController: UIViewController {

    // textViewの上の文字
    let label = UILabel().then {
        $0.text = "テキストを変換"
        $0.font = UIFont.systemFont(ofSize: 20.0)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 変換するボタン
    let convertButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "buttonBody")
        $0.setTitle("変換", for: .normal)
        $0.setTitleColor(UIColor(named: "buttonString"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // 説明を表示するためのボタン
    let descriptionButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "buttonBody")
        $0.setTitle("使用方法", for: .normal)
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
    
    // 説明表示用
    var spotlightView = AwesomeSpotlightView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        initializeViewModel()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpSpotLight()
    }
    
    // ライト・ダークモード切り替え対応
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let pt = previousTraitCollection else { return }
        if #available(iOS 13.0, *) {
            if pt.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
                inputTextView.layer.borderColor = UIColor(named: "border")?.cgColor
            }
        }
    }
    
    // UI初期化
    func initializeUI() {
        self.title = "ふりがなガイド"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        inputTextView.delegate = self
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(label)
        view.addSubview(convertButton)
        view.addSubview(inputTextView)
        view.addSubview(descriptionButton)
        setUpLayout()
    }
    
    // ViewModel初期化
    func initializeViewModel() {
        inputViewModel = InputViewModel(with: gooConvertAPIModel())
    }
    
    // Layout
    func setUpLayout() {
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(30)
            $0.centerX.equalTo(view)
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(label.snp.top).inset(30)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalTo(view)
        }
        
        convertButton.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
            $0.top.equalTo(inputTextView.snp.bottom).inset(-30)
            $0.centerX.equalTo(view)
        }
        
        descriptionButton.snp.makeConstraints {
            $0.width.height.centerX.equalTo(convertButton)
            $0.top.equalTo(convertButton.snp.bottom).inset(-30)
        }
    }
    
    // ボタンとテキストのバインド
    func bindViewModel() {
        let input = InputViewModel.Input(convertTrigger: convertButton.rx.tap.asDriver(),
                                         descriptionTrigger: descriptionButton.rx.tap.asDriver(),
                                         text: inputTextView.rx.text
                                            .map{ if let t = $0 { return t } else { return "" } }
                                            .asDriver(onErrorJustReturn: ""))
        let output = inputViewModel.transform(input: input)
        output.convertedText.drive(onNext: willShow).disposed(by: disposeBag)
        output.descriptionButton.drive(onNext: showDescription).disposed(by: disposeBag)
        output.error.drive(onNext: showError).disposed(by: disposeBag)
    }
    
    
    // 次の画面へ遷移し、変換後のテキストを表示
    // FIX: どうの方法でコードベースで遷移先に飛ばせば良いのか？
    func willShow(result: Result) {
        let vc = OutputViewController()
        vc.outputViewModel = OutputViewModel(with: result)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 説明を表示する
    func showDescription() {
        view.addSubview(spotlightView)
        spotlightView.continueButtonModel.isEnable = true
        spotlightView.skipButtonModel.isEnable = true
        spotlightView.showAllSpotlightsAtOnce = false
        spotlightView.start()
    }
    
    // エラーを表示できるようにした．
    func showError(error: Error) {
        switch error {
        case Exception.generic(let message):
            let alert = CDAlertView(title: "エラー", message: message , type: .error)
            let doneAction = CDAlertViewAction(title: "OK")
            alert.add(action: doneAction)
            alert.show()
        default:
            let alert = CDAlertView(title: "エラー", message: "判別不能" , type: .error)
            let doneAction = CDAlertViewAction(title: "OK")
            alert.add(action: doneAction)
            alert.show()
        }
        
    }
}


extension InputViewController: UITextViewDelegate {
    // キーボード閉じるための設定
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.inputTextView.isFirstResponder) {
            self.inputTextView.resignFirstResponder()
        }
    }
}


// 説明の設定
extension InputViewController: AwesomeSpotlightViewDelegate {
    func spotlightView(_ spotlightView: AwesomeSpotlightView, willNavigateToIndex index: Int) {
    }
    
    func spotlightView(_ spotlightView: AwesomeSpotlightView, didNavigateToIndex index: Int) {
    }
    
    func spotlightViewWillCleanup(_ spotlightView: AwesomeSpotlightView, atIndex index: Int) {
    }
    
    func spotlightViewDidCleanup(_ spotlightView: AwesomeSpotlightView){
    }
    
    func setUpSpotLight() {
        let inputTextViewSpotlightMargin = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        let inputTextViewSpotlight = AwesomeSpotlight(withRect: inputTextView.frame, shape: .rectangle, text: "ここに変換したいテキストを入力．", margin: inputTextViewSpotlightMargin)
        
        let convertButtonSpotlight = AwesomeSpotlight(withRect: convertButton.frame, shape: .rectangle, text: "入力が終わったら、このボタンをタップ🌼")

        let descriptionButtonSpotSpotlight = AwesomeSpotlight(withRect: descriptionButton.frame, shape: .roundRectangle, text: "この説明は、ここから何度でもみれます．")

        
        spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [inputTextViewSpotlight, convertButtonSpotlight, descriptionButtonSpotSpotlight,])
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
    }
}
