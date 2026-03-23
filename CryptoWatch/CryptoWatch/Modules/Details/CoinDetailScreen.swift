import UIKit

class CoinDetailScreen: UIViewController {
    lazy var icon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var symbol: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var titleView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [name, symbol])
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var descr: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 10)
        return label
    }()

    lazy var infoBlock: InfoBlock = {
        let block = InfoBlock()
        block.translatesAutoresizingMaskIntoConstraints = false
        return block
    }()

    var marketModel: MarketModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(icon)
        view.addSubview(titleView)
        view.addSubview(descr)
        view.addSubview(infoBlock)

        let imageSize = 80.0

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(imageSize * 2)),
            icon.widthAnchor.constraint(equalToConstant: imageSize),
            icon.heightAnchor.constraint(equalToConstant: imageSize),

            titleView.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descr.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            descr.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descr.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            descr.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),

            infoBlock.topAnchor.constraint(equalTo: descr.bottomAnchor, constant: 16),
            infoBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoBlock.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        populate()
    }

    func populate() {
        guard let marketModel else { return }

        name.text = marketModel.name
        symbol.text = marketModel.symbol
        descr.text = marketModel.name
        icon.loadImage(urlString: marketModel.icon)
        infoBlock.setChanges24h(value: marketModel.priceChange24H)
        infoBlock.setVolume(value: marketModel.price)
    }
}

class InfoBlock: UIView {
    private lazy var titles: UIStackView = {
        let changes24h = UILabel()
        changes24h.font = .boldSystemFont(ofSize: 14)
        changes24h.translatesAutoresizingMaskIntoConstraints = false
        changes24h.textAlignment = .center
        changes24h.text = "High 24h / Low 24h"

        let volume = UILabel()
        volume.font = .boldSystemFont(ofSize: 14)
        volume.translatesAutoresizingMaskIntoConstraints = false
        volume.textAlignment = .center
        volume.text = "Market Cap / Volume"

        return createRow(subviews: [changes24h, volume])
    }()

    private lazy var changes24h: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()

    private lazy var volume: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setChanges24h(value: Double?) {
        let stringValue = if let value { "\(value)" } else { "" }
        if changes24h.text != stringValue {
            changes24h.text = stringValue
        }
    }

    func setVolume(value: Double?) {
        let stringValue = if let value { "\(value)" } else { "" }
        if volume.text != stringValue {
            volume.text = stringValue
        }
    }

    private func createRow(subviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            titles, createRow(subviews: [changes24h, volume]),
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillEqually

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

#Preview {
    let view = CoinDetailScreen()
    return view
}
