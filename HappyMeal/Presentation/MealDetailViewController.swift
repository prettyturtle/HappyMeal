//
//  MealDetailViewController.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import UIKit
import SnapKit
import Then
import Toast
import PanModal

class MealDetailViewController: UIViewController {
    
    private lazy var dateLabel = UILabel().then {
        $0.text = "22.05.27(금)"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 24.0, weight: .bold)
    }
    private lazy var nextButton = UIButton().then {
        $0.setImage(Icon.arrowRight.image, for: .normal)
    }
    private lazy var prevButton = UIButton().then {
        $0.setImage(Icon.arrowLeft.image, for: .normal)
    }
    private lazy var mealInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16.0, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let schoolInfo: SchoolInfo
    
    init(schoolInfo: SchoolInfo) {
        self.schoolInfo = schoolInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
        
        fetchData(schoolInfo: schoolInfo, dateString: "20220527")
    }
}

// MARK: - Logics
private extension MealDetailViewController {
    func startActivity() {
        view.makeToastActivity(.center)
    }
    func stopActivity() {
        view.hideToastActivity()
    }
    func fetchData(schoolInfo: SchoolInfo, dateString: String) {
        startActivity()
        MealFetcher(schoolInfo: schoolInfo, dateString: dateString).fetchMeal { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mealInfo):
                print(mealInfo.mealInfo)
                DispatchQueue.main.async {
                    self.mealInfoLabel.text = mealInfo.mealInfo
                    self.stopActivity()
                }
            case .failure(_):
                print("ERROR")
                self.stopActivity()
            }
        }
    }
}

// MARK: - @objc Methods
private extension MealDetailViewController {
    @objc func didTapInfoButton() {
        let allergyInfoVC = AllergyInfoViewController()
        presentPanModal(allergyInfoVC, sourceView: nil, sourceRect: .zero)
    }
}

// MARK: - UI Methods
private extension MealDetailViewController {
    func setupNavigationBar() {
        navigationItem.title = schoolInfo.schoolName
        let rightBarButton = UIBarButtonItem(
            image: Icon.info.image,
            style: .plain,
            target: self,
            action: #selector(didTapInfoButton)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [
            prevButton,
            dateLabel,
            nextButton,
            mealInfoLabel
        ].forEach { view.addSubview($0) }
        
        prevButton.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(prevButton.snp.trailing)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.trailing.equalTo(nextButton.snp.leading)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        mealInfoLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        dateLabel.snp.contentHuggingVerticalPriority = 1000.0
        mealInfoLabel.snp.contentHuggingVerticalPriority = 999.0
    }
}
