//
//  ComicCollectionViewCell.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/10/10.
//

import UIKit

// 设置样式
enum ComicCollectionViewCellStyle {
    case none
    case withTitle
    case withTitieAndDesc
}


class ComicCollectionViewCell: BaseCollectionViewCell {
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLable = UILabel()
        titleLable.textColor = UIColor.black
        titleLable.font = UIFont.systemFont(ofSize: 14)
        return titleLable
    }()
    
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.gray
        descLabel.font = UIFont.systemFont(ofSize: 12)
        return descLabel
    }()
    
    override func setupLayout() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        // 设置样式
        var cellStyle: ComicCollectionViewCellStyle = .withTitle {
            didSet {
                switch cellStyle {
                case .none:
                    // 布局更新
                    titleLabel.snp.updateConstraints{ make in
                        make.bottom.equalToSuperview().offset(25)
                    }
                    titleLabel.isHidden = true
                    descLabel.isHidden = true
                case .withTitle:
                    titleLabel.snp.updateConstraints{ make in
                        make.bottom.equalToSuperview().offset(-10)
                    }
                    titleLabel.isHidden = false
                    descLabel.isHidden = true
                case .withTitieAndDesc:
                    titleLabel.snp.updateConstraints{ make in
                        make.bottom.equalToSuperview().offset(-25)
                    }
                    titleLabel.isHidden = false
                    descLabel.isHidden = false
                }
            }
        }
        
        var model: ComicModel? {
            didSet {
                guard let model = model else { return }
                iconView.kf.setImage(urlString: model.cover,
                                     placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
                titleLabel.text = model.name ?? model.title
                descLabel.text = model.subTitle ?? "更新至\(model.content ?? "0")集"
            }
        }
    }
}
