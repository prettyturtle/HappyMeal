//
//  AllergyInfoViewController.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import UIKit
import PanModal

class AllergyInfoViewController: UIViewController, PanModalPresentable {
    var panScrollable: UIScrollView? { return nil }
    var shortFormHeight: PanModalHeight { return .contentHeight(allergyInfoLabel.bounds.height) }
    var longFormHeight: PanModalHeight { return .contentHeight(UIScreen.main.bounds.height / 2.0) }
    
    private let allergyInfoLabel = UILabel().then {
        $0.text = "요리명에 표시된 번호는 알레르기를 유발할 수 있는 식재료입니다. (1. 난류, 2. 우유, 3. 메밀, 4. 땅콩, 5. 대두, 6. 밀, 7. 고등어, 8. 게, 9. 새우, 10. 돼지고기, 11. 복숭아, 12. 토마토, 13. 아황산염, 14. 호두, 15. 닭고기, 16. 쇠고기, 17. 오징어, 18. 조개류(굴, 전복, 홍합 등)"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 16.0, weight: .semibold)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        setupLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        panModalSetNeedsLayoutUpdate()
        panModalTransition(to: .shortForm)
    }
}

private extension AllergyInfoViewController {
    func setupAttribute() {
        view.backgroundColor = .systemBackground
    }
    func setupLayout() {
        view.addSubview(allergyInfoLabel)
        allergyInfoLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
}
