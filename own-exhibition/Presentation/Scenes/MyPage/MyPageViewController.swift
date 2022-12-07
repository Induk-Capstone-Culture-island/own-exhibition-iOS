//
//  MyPageViewController.swift
//  own-exhibition
//
//  Created by 소프트웨어컴퓨터 on 2022/10/28.
//

import UIKit
import RxSwift

final class MyPageViewController: UIViewController {
    
    private var disposeBag: DisposeBag = .init()
    
    private var viewModel: MyPageViewModel!
    
    // MARK: - UI Components
    
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
        addOutLine()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map{ _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = MyPageViewModel.Input.init(
            viewWillAppear: viewWillAppear,
            selectedChangeName: NameChangeButton.rx.tap.asDriver(),
            selectedChangeBirth: BirthChangeButton.rx.tap.asDriver(),
            selectedChangePhoneNumber: PhoneNumberChangeButton.rx.tap.asDriver(),
            selectedChangePassword: PasswordChangeButton.rx.tap.asDriver(),
            tapLogoutButton: LogoutButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive(myPageBinding)
            .disposed(by: disposeBag)
        
        output.selectedChangeName
            .drive()
            .disposed(by: disposeBag)
        
        output.selectedChangeBirth
            .drive()
            .disposed(by: disposeBag)
        
        output.selectedChangePhoneNumber
            .drive()
            .disposed(by: disposeBag)
        
        output.selectedChangePassword
            .drive()
            .disposed(by: disposeBag)
        
        output.didTapLogoutButton
            .emit()
            .disposed(by: disposeBag)
    }
    
    private var myPageBinding: Binder<UserInfo> {
        return .init(self, binding: { vc, userInfo in
            vc.EmailLabel.text = userInfo.email
            vc.NameLabel.text = userInfo.name
            vc.BirthLabel.text = {
                let formatter: DateFormatter = .init()
                formatter.dateFormat = "yyyy.MM.dd"
                return formatter.string(from: userInfo.birth)
            }()
            vc.PhoneNumberLabel.text = userInfo.phoneNumber
        })
    }

    func setViewModel(by viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
    
    func addOutLine() {
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
