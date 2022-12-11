//
//  ViewController.swift
//  AmazonShopping
//
//  Created by Felipe Lima on 10/12/22.
//

import UIKit

struct TextCellViewModel {
    let text: String
    let font: UIFont
}

enum SectionType {
    case productPhotos(images: [UIImage])
    case productInfo(viewModels: [TextCellViewModel])
    case relatedProducts(viewModels: [RelatedProductTableViewCellViewModel])
    
    var title: String? {
        switch self {
        case .relatedProducts:
            return "Related Products"
        default:
            return nil
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        table.register(PhotoCarouselTableViewCell.self, forCellReuseIdentifier: PhotoCarouselTableViewCell.identifier)
        table.register(RelatedProductTableViewCell.self, forCellReuseIdentifier: RelatedProductTableViewCell.identifier)
        return table
    }()
    
    private lazy var sections = [SectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSection()
        title = "Alexa Echo Dot"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureSection() {
        sections.append(.productPhotos(images: [
            UIImage(named: "photo1"),
            UIImage(named: "photo2"),
            UIImage(named: "photo3"),
            UIImage(named: "photo4")
        ].compactMap({ $0 })))
        sections.append(.productInfo(viewModels: [
            TextCellViewModel(text: "Echo dot is a great home speaker device from Amazon to do stuff. Echo dot is a great home speaker device from Amazon to do stuff. Echo dot is a great home speaker device from Amazon to do stuff. Echo dot is a great home speaker device from Amazon to do stuff.", font: .systemFont(ofSize: 18)),
            TextCellViewModel(text: "Price: $49.99", font: .systemFont(ofSize: 22))
        ]))
        sections.append(.relatedProducts(viewModels: [
            RelatedProductTableViewCellViewModel(image: UIImage(named: "related1"), title: "Echo Essential"),
            RelatedProductTableViewCellViewModel(image: UIImage(named: "related2"), title: "Echo Show"),
            RelatedProductTableViewCellViewModel(image: UIImage(named: "related3"), title: "Echo Original"),
            RelatedProductTableViewCellViewModel(image: UIImage(named: "related4"), title: "Echo Television"),
        ]))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .productPhotos:
            return 1
        case .productInfo(let viewModels):
            return viewModels.count
        case .relatedProducts(let viewModels):
            return viewModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = sections[section]
        return sectionType.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .productPhotos(let images):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCarouselTableViewCell.identifier, for: indexPath) as? PhotoCarouselTableViewCell else {
                fatalError()
            }
            cell.configure(with: images)
            return cell
        case .productInfo(let viewModels):
            let viewModel = viewModels[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.configure(with: viewModel)
            return cell
        case .relatedProducts(let viewModels):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RelatedProductTableViewCell.identifier, for: indexPath) as? RelatedProductTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .productPhotos:
            return view.frame.size.width
        case .relatedProducts:
            return 150
        case .productInfo:
            return UITableView.automaticDimension
            
        }
    }
}

extension UITableViewCell {
    func configure(with viewModel: TextCellViewModel) {
        textLabel?.text = viewModel.text
        textLabel?.numberOfLines = 0
        textLabel?.font = viewModel.font
    }
}
