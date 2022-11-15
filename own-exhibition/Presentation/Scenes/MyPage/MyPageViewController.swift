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
    
    //마이페이지 View
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var NameView: UIView!
    @IBOutlet weak var BirthView: UIView!
    @IBOutlet weak var PhoneNumberView: UIView!
    @IBOutlet weak var PasswordChangeView: UIView!
    
    //마이페이지 Button
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var WithdrawalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        //마이페이지 View 사이 줄
        EmailView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        NameView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        BirthView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        PhoneNumberView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        PasswordChangeView.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        LogoutButton.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
        WithdrawalButton.layer.addBorder([.bottom], color: UIColor.darkGray, width: 1.0)
    }
    
    func bindViewModel() {
        let input = MyPageViewModel.Input.init()
        let output = viewModel.transform(input: input)

        _ = output
    }
    
    func setViewModel(by viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
}
