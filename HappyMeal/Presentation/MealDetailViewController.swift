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
import Floaty

class MealDetailViewController: UIViewController {
    
    private lazy var dateLabel = UILabel().then {
        $0.text = getDateString(date: Date.now, dateFormat: "yy.MM.dd(E)")
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 24.0, weight: .bold)
    }
    private lazy var nextButton = UIButton().then {
        $0.setImage(Icon.arrowRight.image, for: .normal)
        $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    private lazy var prevButton = UIButton().then {
        $0.setImage(Icon.arrowLeft.image, for: .normal)
        $0.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
    }
    private lazy var mealInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16.0, weight: .semibold)
        $0.numberOfLines = 0
        $0.isUserInteractionEnabled = true
        let leftSwipegesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeMealInfo(_:)))
        let rightSwipegesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeMealInfo(_:)))
        leftSwipegesture.direction = .left
        rightSwipegesture.direction = .right
        $0.addGestureRecognizer(leftSwipegesture)
        $0.addGestureRecognizer(rightSwipegesture)
    }
    private lazy var floatyButton = Floaty().then {
        $0.buttonColor = .systemBlue
        $0.plusColor = .white
        $0.itemImageColor = .darkGray
        $0.addItem(icon: Icon.house.image, handler: didTapMySchoolButton(item:))
        $0.addItem(icon: Icon.share.image, handler: didTapShareButton(item:))
    }
    
    private let schoolInfo: SchoolInfo
    private var now = Date.now
    
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
        setupAttribute()
        setupLayout()
        nowDateFetchData()
    }
}

// MARK: - Logics
private extension MealDetailViewController {
    func didTapMySchoolButton(item: FloatyItem) {
        UserDefaultsManager.shared.setMySchool(schoolInfo: schoolInfo) { result in
            switch result {
            case .success(_):
                self.view.makeToast("마이 스쿨 등록 성공!")
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    func didTapShareButton(item: FloatyItem) {
        let shareObject: [Any] = ["\(schoolInfo.schoolName) 급식 정보", view.asImage()]
        let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        floatyButton.close()
        present(activityViewController, animated: true)
    }
    func nextOrPrevDateString(value: Int) -> String {
        let newDate = Calendar.current.date(byAdding: .day, value: value, to: now) ?? now
        now = newDate
        return getDateString(date: newDate, dateFormat: "yyyyMMdd")
    }
    func nowDateFetchData() {
        let nowDateString = getDateString(date: now, dateFormat: "yyyyMMdd")
        fetchData(schoolInfo: schoolInfo, dateString: nowDateString)
    }
    func getDateString(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
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
                DispatchQueue.main.async {
                    self.mealInfoLabel.text = mealInfo.mealInfo.trimmed.translateHtml
                    self.stopActivity()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.mealInfoLabel.text = "급식 정보가 없습니다."
                    self.stopActivity()
                }
            }
        }
    }
}

// MARK: - @objc Methods
private extension MealDetailViewController {
    @objc func swipeMealInfo(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .left:
            didTapNextButton()
        case .right:
            didTapPrevButton()
        default:
            break
        }
    }
    @objc func didTapNextButton() {
        fetchData(schoolInfo: schoolInfo, dateString: nextOrPrevDateString(value: 1))
        dateLabel.text = getDateString(date: now, dateFormat: "yy.MM.dd(E)")
    }
    @objc func didTapPrevButton() {
        fetchData(schoolInfo: schoolInfo, dateString: nextOrPrevDateString(value: -1))
        dateLabel.text = getDateString(date: now, dateFormat: "yy.MM.dd(E)")
    }
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
    func setupAttribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        [
            prevButton,
            dateLabel,
            nextButton,
            mealInfoLabel,
            floatyButton
        ].forEach { view.addSubview($0) }
        
        let commonSpacing: CGFloat = 16.0
        
        prevButton.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(commonSpacing)
        }
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(prevButton.snp.trailing)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(commonSpacing)
            $0.trailing.equalTo(nextButton.snp.leading)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonSpacing)
        }
        mealInfoLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(commonSpacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonSpacing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(commonSpacing)
        }
        dateLabel.snp.contentHuggingVerticalPriority = 1000.0
        mealInfoLabel.snp.contentHuggingVerticalPriority = 999.0
    }
}
