//
//  ToiletTableViewCell.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 14/10/2022.
//

import UIKit

class ToiletTableViewCell: UITableViewCell {
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(named: "ratp_blue")
        view.layer.cornerRadius = 8
        // view.clipsToBounds = false
        return view
    }()
    
    private lazy var toiletImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.image = UIImage(named: "wc")
        return image
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var openingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemOrange
        return label
    }()
    
    private lazy var reducedMobilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(named: "ratp_jade_green")
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .cyan
        return label
    }()
    
    func configure(with viewModel: ToiletViewModel) {
        addressLabel.text = viewModel.address
        openingLabel.text = viewModel.opening
        reducedMobilityLabel.text = "Accessible PMR: " + viewModel.reducedMobility
        distanceLabel.text = viewModel.distance
        
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(cellView)
        cellView.addSubview(toiletImage)
        cellView.addSubview(addressLabel)
        cellView.addSubview(openingLabel)
        cellView.addSubview(reducedMobilityLabel)
        cellView.addSubview(distanceLabel)
    }
    
    private func setConstraints() {
        
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        toiletImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        toiletImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        toiletImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toiletImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        distanceLabel.centerXAnchor.constraint(equalTo: toiletImage.centerXAnchor).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: reducedMobilityLabel.centerYAnchor).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: toiletImage.trailingAnchor, constant: 10).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10).isActive = true
        
        openingLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        openingLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor).isActive = true
        openingLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10).isActive = true
        
        reducedMobilityLabel.topAnchor.constraint(equalTo: openingLabel.bottomAnchor, constant: 10).isActive = true
        reducedMobilityLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor).isActive = true
        reducedMobilityLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10).isActive = true
        reducedMobilityLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.backgroundView = UIView()
        buildViewHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 150)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CustomTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        /*
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            UIViewPreview {
                let view = ToiletTableViewCell()
                view.configure(with: ToiletViewModel(address: "2 AVENUE DE WAGRAM, 75017 Paris", opening: "24h/24", reducedMobility: "Oui", distance: "5 km"))
                return view
            }
            .previewLayout(PreviewLayout.sizeThatFits)
            .preferredColorScheme(colorScheme)
            .previewDisplayName("CustomTableViewCell (\(colorScheme))")
        }
         */
        UIViewPreview {
            let view = ToiletTableViewCell()
            view.configure(with: ToiletViewModel(address: "2 AVENUE DE WAGRAM, 75017 Paris", opening: "24h/24", reducedMobility: "Oui", distance: "5 km"))
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CustomTableViewCell (dark)")
    }
}
#endif
