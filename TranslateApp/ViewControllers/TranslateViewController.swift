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
    
    init(viewModel: TranslateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var cancellables = Set<AnyCancellable>()
    
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

    
    private lazy var sourseLanTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = ConstColors.lightGreen.withAlphaComponent(0.9)
        textView.text = "Enter Word to Translate"
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 20, weight: .regular)
        textView.textAlignment = .left
        textView.tag = 1
        textView.autocorrectionType = .no
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private lazy var deatinationLanTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = ConstColors.lightGreen.withAlphaComponent(0.9)
        textView.text = "Translate Word"
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 20, weight: .regular)
        textView.textAlignment = .left
        textView.tag = 2
        textView.showsVerticalScrollIndicator = false
        textView.isUserInteractionEnabled = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
        setConstrains()
        setDelegates()
    }
    
    private func observeData(){
        viewModel.$dataTranslations
            .dropFirst()
            .sink { [unowned self] translations in
                changeColorToBlackPlaceHoler(textView: self.deatinationLanTextView)
                self.deatinationLanTextView.text = translations
                
            }
            .store(in: &cancellables)
        
        viewModel.$plsceHolderDest
            .dropFirst()
            .sink { [unowned self] placeholder in
                self.deatinationLanTextView.textColor = UIColor.lightGray
                self.deatinationLanTextView.text = placeholder
            }
            .store(in: &cancellables)
        
    }
    private func setDelegates(){
        sourseLanTextView.delegate = self
    }
    
    private func changeColorToBlackPlaceHoler(textView: UITextView){
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}

// MARK: - UITextViewDelegate
extension TranslateViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        changeColorToBlackPlaceHoler(textView: textView)
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
            deatinationLanTextView,
            
        ].forEach { backView.addSubview($0) }
        
        backView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        sourseLanTextView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).inset(32)
            $0.trailing.equalTo(backView.snp.trailing).inset(16)
            $0.leading.equalTo(backView.snp.leading).inset(16)
            $0.height.equalTo(220)
        }
        
        deatinationLanTextView.snp.makeConstraints {
            $0.top.equalTo(sourseLanTextView.snp.bottom).inset(-32)
            $0.trailing.equalTo(backView.snp.trailing).inset(16)
            $0.leading.equalTo(backView.snp.leading).inset(16)
            $0.height.equalTo(220)
        }
        
    }
}
