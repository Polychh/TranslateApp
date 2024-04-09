//
//  ViewController.swift
//  TranslateApp
//
//  Created by Polina on 09.04.2024.
//

import UIKit
import SnapKit
import Combine

class TranslateViewController: UIViewController {
    
    private let viewModel: TranslateViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let sourseLanTextView = UITextView()
    private let destinationLanTextView = UITextView()
    private let languageButtonSource = UIButton()
    private let languageButtonDest = UIButton()
    
    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ConstColors.green.withAlphaComponent(0.8)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        view.layer.shadowColor =  ConstColors.lightGreen.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 8
        return view
    }()
    
    init(viewModel: TranslateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        congigUi()
        observeData()
        setConstrains()
        setDelegates()
      
    }
    
    private func observeData(){
        viewModel.$dataTranslations
            .dropFirst()
            .sink { [unowned self] translations in
                destinationLanTextView.textColor = .white
                destinationLanTextView.text = translations
                
            }
            .store(in: &cancellables)
        
        viewModel.$placeHolderDest
            .dropFirst()
            .sink { [unowned self] placeholder in
                destinationLanTextView.textColor = .gray
                destinationLanTextView.text = placeholder
            }
            .store(in: &cancellables)
        
    }
    
    private func setDelegates(){
        sourseLanTextView.delegate = self
    }
}

// MARK: - configUI
private extension TranslateViewController{
    
    func congigUi(){
        configMenu(type: .dest, button: languageButtonDest)
        configMenu(type: .source, button: languageButtonSource)
        configTextView(textView: sourseLanTextView, title: "Enter Word to Translate", isUserIteraction: true, tag: 1)
        configTextView(textView: destinationLanTextView, title: "Translated Word", isUserIteraction: false, tag: 2)
        configButtons(button: languageButtonDest)
        configButtons(button: languageButtonSource)
    }
    
    func changeColorPlaceHoler(textView: UITextView){
        textView.text = ""
        textView.textColor = UIColor.white
    }
    
    func configMenu(type: lanType, button: UIButton){
        let menu = UIMenu(title: "Chose language",children: createMenuChildren(type: type, buttonType: button))
        switch type{
        case .source:
            button.setTitle(viewModel.languages.first?.typeLabel, for: .normal)
        case .dest:
            button.setTitle(viewModel.languages.last?.typeLabel, for: .normal)
        }
        button.showsMenuAsPrimaryAction = true
        button.menu = menu
    }
    
    func configTextView(textView: UITextView, title: String, isUserIteraction: Bool, tag: Int){
        textView.backgroundColor = ConstColors.lightGreen.withAlphaComponent(0.9)
        textView.text = title
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 20, weight: .regular)
        textView.textAlignment = .left
        textView.tag = tag
        textView.autocorrectionType = .no
        textView.showsVerticalScrollIndicator = false
        textView.isUserInteractionEnabled = isUserIteraction
    }
    
    func configButtons(button: UIButton){
        button.layer.cornerRadius = 12
        button.backgroundColor = ConstColors.lightGreen
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func createMenuChildren(type: lanType, buttonType: UIButton) -> [UIAction]{
        return viewModel.languages.map { lan in
            UIAction(title: lan.typeLabel, handler: { [unowned self] action in
                self.viewModel.changeLanSourseOrDest(type: type, newlan: lan.typeValue)
                buttonType.setTitle(action.title, for: .normal)
            })
        }
    }
}
// MARK: - UITextViewDelegate
extension TranslateViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        changeColorPlaceHoler(textView: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag{
        case 1:
            viewModel.translateWords(text: textView.text)
        default:
            break
        }
    }
}
// MARK: - SetConstrains
private extension TranslateViewController{
    
    func setConstrains(){
        view.backgroundColor = ConstColors.darkGreen
        view.addSubview(backView)
        [
            sourseLanTextView,
            destinationLanTextView,
            languageButtonSource,
            languageButtonDest
            
        ].forEach { backView.addSubview($0) }
        
        languageButtonSource.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(16)
            $0.trailing.equalTo(backView.snp.trailing).inset(16)
            $0.leading.equalTo(backView.snp.leading).inset(16)
            $0.height.equalTo(30)
        }
        
        backView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        sourseLanTextView.snp.makeConstraints {
            $0.top.equalTo(languageButtonSource.snp.bottom).offset(16)
            $0.trailing.equalTo(backView.snp.trailing).inset(16)
            $0.leading.equalTo(backView.snp.leading).inset(16)
            $0.height.equalTo(220)
        }
        
        destinationLanTextView.snp.makeConstraints {
            $0.top.equalTo(sourseLanTextView.snp.bottom).inset(-32)
            $0.trailing.equalTo(backView.snp.trailing).inset(16)
            $0.leading.equalTo(backView.snp.leading).inset(16)
            $0.height.equalTo(220)
        }
        
        languageButtonDest.snp.makeConstraints {
            $0.top.equalTo(destinationLanTextView.snp.bottom).offset(16)
            $0.trailing.equalTo(backView.snp.trailing).inset(16)
            $0.leading.equalTo(backView.snp.leading).inset(16)
            $0.height.equalTo(30)
        }
    }
}
