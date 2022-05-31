//
//  SearchViewController.swift
//  HappyMeal
//
//  Created by yc on 2022/05/30.
//

import UIKit
import SnapKit
import Then
import Toast

class SearchViewController: UIViewController {
    private lazy var searchController = UISearchController().then {
        $0.searchBar.placeholder = "학교명 검색..."
        $0.searchBar.delegate = self
        $0.searchBar.autocapitalizationType = .none
        $0.searchBar.autocorrectionType = .no
        $0.searchBar.returnKeyType = .search
    }
    private lazy var schoolTableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    var schools = [SchoolInfoResponse.SchoolInfo.Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = schools[indexPath.row]
        let schoolInfo = SchoolInfo(schoolCode: school.schoolCode,
                                    officeCode: school.officeCode,
                                    schoolName: school.schoolName)
        let mealDetailVC = MealDetailViewController(schoolInfo: schoolInfo)
        navigationController?.pushViewController(mealDetailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(schools[indexPath.row].schoolName)"
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            fetchData(schoolName: searchBar.text!)
        }
    }
}

// MARK: - Logics
private extension SearchViewController {
    func startActivity() {
        view.makeToastActivity(.center)
    }
    func stopActivity() {
        view.hideToastActivity()
    }
    func fetchData(schoolName: String) {
        startActivity()
        SchoolInfoFetcher(schoolName: schoolName).fetchAllSchool { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let schools):
                self.schools = schools
                self.view.makeToast("검색 완료!")
                DispatchQueue.main.async {
                    self.schoolTableView.reloadData()
                    self.stopActivity()
                }
            case .failure(_):
                self.view.makeToast("학교명을 정확하게 입력하세요.")
                self.stopActivity()
            }
        }
    }
}

// MARK: - @objc Methods
private extension SearchViewController {
    @objc func didTapMySchoolButton() {
        guard let schoolInfo = UserDefaultsManager.shared.getMySchool() else { return }
        navigationController?.pushViewController(MealDetailViewController(schoolInfo: schoolInfo), animated: true)
    }
}

// MARK: - UI Methods
private extension SearchViewController {
    func setupNavigationBar() {
        navigationItem.title = "학교 검색"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let rightBarButton = UIBarButtonItem(
            image: Icon.house.image,
            style: .plain,
            target: self,
            action: #selector(didTapMySchoolButton)
        )
        navigationItem.rightBarButtonItem = rightBarButton
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [schoolTableView].forEach { view.addSubview($0) }
        schoolTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
