import UIKit

class CoinCell: UITableViewCell {
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(icon)
        contentView.addSubview(leftContainer)
        contentView.addSubview(rightContainer)

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
        ])
    }

    func populate() {
        title.text = "Title"
        symbol.text = "Symbol"
        price.text = "Price"
        changes.text = "Changes"
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
    cell.populate()
    return cell
}
