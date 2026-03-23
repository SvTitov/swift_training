import UIKit

class CoinCell: UITableViewCell {
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var symbol: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var changes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var leftContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, symbol])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    lazy var rightContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [price, changes])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    lazy var loadingView: UIActivityIndicatorView = {
        let refresh = UIActivityIndicatorView(style: .medium)
        refresh.translatesAutoresizingMaskIntoConstraints = false
        return refresh
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    func setupUI() {
        contentView.addSubview(icon)
        contentView.addSubview(leftContainer)
        contentView.addSubview(rightContainer)
        contentView.addSubview(loadingView)

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.heightAnchor.constraint(equalToConstant: 40),

            leftContainer.leadingAnchor.constraint(
                equalTo: icon.trailingAnchor, constant: 12),
            leftContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            rightContainer.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            rightContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightContainer.leadingAnchor.constraint(
                greaterThanOrEqualTo: leftContainer.trailingAnchor, constant: 12),

            loadingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

        ])
    }

    func populate(_ model: MarketModel) {
        icon.loadImage(urlString: model.icon)
        loadingView.stopAnimating()
        title.isHidden = false
        symbol.isHidden = false
        price.isHidden = false
        changes.isHidden = false

        title.text = model.name
        symbol.text = model.symbol
        price.text = "\(model.price)"
        changes.text = "\(model.priceChange24H)"
    }

    func loadingState() {
        loadingView.startAnimating()
        title.isHidden = true
        symbol.isHidden = true
        price.isHidden = true
        changes.isHidden = true
    }

    override func prepareForReuse() {
        icon.image = nil
        title.text = nil
        symbol.text = nil
        price.text = nil
        changes.text = nil
        changes.textColor = .secondaryLabel
    }
}

#Preview {
    let cell = CoinCell()
    return cell
}
