//
//  MyPageViewController.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/10/28.
//

import UIKit
import RxSwift
import RxCocoa


class MyPageViewController: UIViewController {
   
    private let disposeBag = DisposeBag.init()
    
    private var viewModel : MyPageViewModel!
    
    //마이페이지 View
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var NameView: UIView!
    @IBOutlet weak var BirthView: UIView!
    @IBOutlet weak var PhoneNumberView: UIView!
    @IBOutlet weak var PasswordChangeView: UIView!
    
    //마이페이지 Button
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var WithdrawalButton: UIButton!
    @IBOutlet weak var NameChangeButton: UIButton!
    @IBOutlet weak var BirthChangeButton: UIButton!
    @IBOutlet weak var PhoneNumberChangeButton: UIButton!
    @IBOutlet weak var PasswordChangeButton: UIButton!
    
    //마이페이지 Label
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var BirthLabel: UILabel!
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        line()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map{ _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = MyPageViewModel.Input.init(
            viewWillAppear: viewWillAppear,
            selection: PasswordChangeButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.personalInfo
            .drive(myPageBinding)
            .disposed(by: disposeBag)
        
        output.selectedChangeInfo
            .drive()
            .disposed(by: disposeBag)
        
    }
    
    private var myPageBinding: Binder<PersonalInfo>{
        return .init(self, binding: {vc, personalInfo in
            vc.EmailLabel.text = personalInfo.email
            vc.NameLabel.text = personalInfo.name
            vc.BirthLabel.text = {
                let formatter: DateFormatter = .init()
                formatter.dateFormat = "yyyy.MM.dd"
                return formatter.string(from: personalInfo.birth)
            }()
            vc.PhoneNumberLabel.text = personalInfo.phoneNumber
        })
    }


    func setViewModel(by viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
    
    func line(){
        //마이페이지 View 사이 줄
        EmailView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        NameView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        BirthView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        PhoneNumberView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        PasswordChangeView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        LogoutButton.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        WithdrawalButton.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
    }
}
