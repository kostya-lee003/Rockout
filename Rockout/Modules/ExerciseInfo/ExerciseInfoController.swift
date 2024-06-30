//
//  ExerciseInfoController.swift
//  Rockout
//
//  Created by Kostya Lee on 09/12/23.
//

import Foundation
import UIKit

public class ExerciseInfoController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
//    private let subtitleLabel = UILabel()
//    private let imgView = UIImageView()
//    private let descriptionLabel = UILabel()
    private let descriptionValueLabel = UISelectableLabel()
    
    private let model: ExerciseDataEntity
    
//    private let networkManager = NetworkManager()
    
    init(_ model: ExerciseDataEntity) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.populate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateHideTabBar()
    }
    
    private func initViews() {
        self.view.backgroundColor = .white
        self.title = "Описание упражнения"
        self.hidesBottomBarWhenPushed = true
        
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .primaryLabel
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        
//        subtitleLabel.font = .systemFont(ofSize: 20)
//        subtitleLabel.textColor = .secondaryLabel
//        subtitleLabel.textAlignment = .left
//        self.contentView.addSubview(subtitleLabel)
//        
//        self.contentView.addSubview(imgView)
//        
//        descriptionLabel.text = "Описание"
//        descriptionLabel.font = .systemFont(ofSize: 20, weight: .medium)
//        descriptionLabel.textColor = .primaryLabel
//        descriptionLabel.textAlignment = .left
//        self.contentView.addSubview(descriptionLabel)
        
        descriptionValueLabel.font = .systemFont(ofSize: 19)
        descriptionValueLabel.textColor = .primaryLabel
        descriptionValueLabel.textAlignment = .left
        descriptionValueLabel.numberOfLines = 0
        self.contentView.addSubview(descriptionValueLabel)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        populate()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.top.equalTo(scrollView.snp.top)
            
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(1200)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.top.equalToSuperview().offset(padding)
            make.width.equalTo(view.frameWidth - padding*2)
        }
        
//        self.subtitleLabel.snp.makeConstraints { make in
//            make.left.equalTo(view.snp.left).offset(CGFloat.globalPadding)
//            make.top.equalTo(titleLabel.snp.bottom)
//            make.right.equalTo(view.snp.right).offset(-CGFloat.globalPadding)
//        }
//        
//        self.imgView.snp.makeConstraints { make in
//            make.left.equalToSuperview()
//            make.top.equalTo(subtitleLabel.snp.bottom)
//            make.height.equalTo(view.frameWidth)
//            make.width.equalTo(view.frameWidth)
//        }
//
//        self.descriptionLabel.snp.makeConstraints { make in
//            make.left.equalTo(view.snp.left).offset(CGFloat.globalPadding)
//            make.top.equalTo(imgView.snp.bottom)
//            make.right.equalTo(view.snp.right).offset(-CGFloat.globalPadding)
//        }

        self.descriptionValueLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(padding)
//            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.right.equalTo(view.snp.right).offset(-padding)
        }
    }

    public func populate() {
        self.titleLabel.text = namesDict[model.id ?? ""]
//        self.subtitleLabel.text = model.target
        self.descriptionValueLabel.text = descriptionsDict[model.id ?? ""]
    }

//    private func loadGif() {
//        // Check the docs to understand reason why I am requesting in such way:
//        // https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb/details
//        networkManager.getExercise(id: model.id ?? "") { [weak self] exercise in
//            guard let self else { return }
//            self.networkManager.getImage(exercise.gifUrl) { [weak self] data in
//                DispatchQueue.main.async { [weak self] in
//                    guard let data, let self else {
//                        NSLog(commonLogFormat, "Data is nil: networkManager.getImage()")
//                        return
//                    }
////                    self.imgView.image = UIImage.gifImageWithData(data)
//                }
//            }
//        }
//    }
}
