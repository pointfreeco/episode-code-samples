import UIKitNavigation

@Perceptible
class FooBar {}
struct Foo: View {
  @Perception.Bindable var x: FooBar

  init(x: FooBar) {
    self.x = x
  }

  var body: some View { EmptyView() }
}

@Perceptible
@MainActor
class SearchNetworksModel {
  var destination: Destination?
  var foundNetworks: [Network]
  var isOn: Bool
  var selectedNetworkID: Network.ID?

  @CasePathable
  enum Destination {
    case connect(ConnectToNetworkModel)
    case detail(NetworkDetailModel)
  }

  init(
    foundNetworks: [Network] = [],
    isOn: Bool = true,
    selectedNetworkID: Network.ID? = nil
  ) {
    self.foundNetworks = foundNetworks
    self.isOn = isOn
    self.selectedNetworkID = selectedNetworkID
  }

  func infoButtonTapped(network: Network) {
    self.destination = .detail(
      NetworkDetailModel(network: network) { [weak self] in
        guard let self else { return }
        destination = nil
        selectedNetworkID = nil
      }
    )
  }

  func networkTapped(_ network: Network) {
    if network.id == selectedNetworkID {
      infoButtonTapped(network: network)
    } else if network.isSecured {
      destination = .connect(
        ConnectToNetworkModel(
          network: network,
          onConnect: { [weak self] network in
            guard let self else { return }
            destination = nil
            selectedNetworkID = network.id
          }
        )
      )
    } else {
      self.selectedNetworkID = network.id
    }
  }
}

class SearchNetworksViewController: UICollectionViewController {
  @UIBindable var model: SearchNetworksModel
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

  init(model: SearchNetworksModel) {
    self.model = model
    super.init(
      collectionViewLayout: UICollectionViewCompositionalLayout.list(
        using: UICollectionLayoutListConfiguration(appearance: .insetGrouped)
      )
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Wi-Fi"

    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
      [weak self] cell, indexPath, item in

      guard let self else { return }
      configure(cell: cell, indexPath: indexPath, item: item)
    }

    self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(
      collectionView: self.collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: item
      )
    }

    _perceive { [weak self] in
      guard let self else { return }
      dataSource.apply(model.dataSourceSnapshot(), animatingDifferences: true)
    }

    self.present(item: $model.destination.connect) { model in
      UINavigationController(
        rootViewController: ConnectToNetworkViewController(model: model)
      )
    }

    self.navigationController?.pushViewController(item: $model.destination.detail) { model in
      NetworkDetailViewController(model: model)
    }
  }

  private func configure(
    cell: UICollectionViewListCell,
    indexPath: IndexPath,
    item: Item
  ) {
    var configuration = cell.defaultContentConfiguration()
    defer { cell.contentConfiguration = configuration }
    cell.accessories = []

    switch item {
    case .isOn:
      configuration.text = "Wi-Fi"
      cell.accessories = [
        .customView(
          configuration: UICellAccessory.CustomViewConfiguration(
            customView: UISwitch(isOn: $model.isOn),
            placement: .trailing(displayed: .always)
          )
        )
      ]

    case let .selectedNetwork(networkID):
      guard let network = model.foundNetworks.first(where: { $0.id == networkID })
      else { return }
      configureNetwork(cell: cell, network: network, indexPath: indexPath, item: item)

    case let .foundNetwork(network):
      configureNetwork(cell: cell, network: network, indexPath: indexPath, item: item)
    }

    func configureNetwork(
      cell: UICollectionViewListCell,
      network: Network,
      indexPath: IndexPath,
      item: Item
    ) {
      configuration.text = network.name
      cell.accessories.append(
        .detail(displayed: .always) { [weak self] in
          guard let self else { return }
          model.infoButtonTapped(network: network)
        }
      )
      if network.isSecured {
        let image = UIImage(systemName: "lock.fill")!
        let imageView = UIImageView(image: image)
        imageView.tintColor = .darkText
        cell.accessories.append(
          .customView(
            configuration: UICellAccessory.CustomViewConfiguration(
              customView: imageView,
              placement: .trailing(displayed: .always)
            )
          )
        )
      }
      let image = UIImage(systemName: "wifi", variableValue: network.connectivity)!
      let imageView = UIImageView(image: image)
      imageView.tintColor = .darkText
      cell.accessories.append(
        .customView(
          configuration: UICellAccessory.CustomViewConfiguration(
            customView: imageView,
            placement: .trailing(displayed: .always)
          )
        )
      )
      if network.id == model.selectedNetworkID {
        cell.accessories.append(
          .customView(
            configuration: UICellAccessory.CustomViewConfiguration(
              customView: UIImageView(image: UIImage(systemName: "checkmark")!),
              placement: .leading(displayed: .always),
              reservedLayoutWidth: .custom(1)
            )
          )
        )
      }
    }
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    shouldSelectItemAt indexPath: IndexPath
  ) -> Bool {
    indexPath.section != 0 || indexPath.row != 0
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let network = dataSource.itemIdentifier(for: indexPath)?.foundNetwork
    else { return }
    model.networkTapped(network)
  }

  enum Section: Hashable, Sendable {
    case top
    case foundNetworks
  }

  @CasePathable
  @dynamicMemberLookup
  enum Item: Hashable, Sendable {
    case isOn
    case selectedNetwork(Network.ID)
    case foundNetwork(Network)
  }
}

extension SearchNetworksModel {
  func dataSourceSnapshot() -> NSDiffableDataSourceSnapshot<
    SearchNetworksViewController.Section,
    SearchNetworksViewController.Item
  > {
    var snapshot = NSDiffableDataSourceSnapshot<
      SearchNetworksViewController.Section,
      SearchNetworksViewController.Item
    >()

    snapshot.appendSections([.top])
    snapshot.appendItems([.isOn], toSection: .top)

    guard isOn
    else { return snapshot }

    if let selectedNetworkID {
      snapshot.appendItems([.selectedNetwork(selectedNetworkID)], toSection: .top)
    }

    snapshot.appendSections([.foundNetworks])
    snapshot.appendItems(
      foundNetworks
        .sorted { lhs, rhs in
          (lhs.isSecured ? 1 : 0, lhs.connectivity)
          > (rhs.isSecured ? 1 : 0, rhs.connectivity)
        }
        .compactMap { network in
          network.id == selectedNetworkID
          ? nil
          : .foundNetwork(network)
        }
      ,
      toSection: .foundNetworks
    )

    return snapshot
  }
}

#Preview {
  let model = SearchNetworksModel(foundNetworks: .mocks)
  return UIViewControllerRepresenting {
    UINavigationController(
      rootViewController: SearchNetworksViewController(model: model)
    )
  }
  .task {
    while true {
      try? await Task.sleep(for: .seconds(1))
      guard Bool.random() else { continue }
      if Bool.random() {
        guard let randomIndex = (0..<model.foundNetworks.count).randomElement()
        else { continue }
        if model.foundNetworks[randomIndex].id != model.selectedNetworkID {
          model.foundNetworks.remove(at: randomIndex)
        }
      } else {
        model.foundNetworks.append(
          Network(
            name: goofyWiFiNames.randomElement()!,
            isSecured: !(1...1_000).randomElement()!.isMultiple(of: 5),
            connectivity: Double((1...100).randomElement()!) / 100
          )
        )
      }
    }
  }
}

extension [Network] {
  static let mocks = [
    Network(
      name: "nachos",
      isSecured: true,
      connectivity: 0.5
    ),
    Network(
      name: "nachos 5G",
      isSecured: true,
      connectivity: 0.75
    ),
    Network(
      name: "Blob Jr's LAN PARTY",
      isSecured: true,
      connectivity: 0.2
    ),
    Network(
      name: "Blob's World",
      isSecured: false,
      connectivity: 1
    ),
  ]
}


// TODO: got this list from the internet, remove anything dumb or offensive
let goofyWiFiNames = [
  "AirSpace1",
  "Living Room",
  "Courage",
  "Nacho WiFi",
  "FBI Surveillance Van",
  "Peacock-Swagger",
  "GingerGymnist",
  "Second Floor",
  "Evergreen",
  "__hidden_in_plain__sight__",
  "MarketingDropBox",
  "HamiltonVille",
  "404NotFound",
  "SNAGVille",
  "Overland101",
  "TheRoomWiFi",
  "PrivateSpace",
  "$12.99/hr WIFI",
  "Drop It Like Its Hotspot",
  "Keep It On The Download",
  "Panic At The Cisco",
  "Bill Wi the Science Fi",
  "Hogwarts Hall of Wifi",
  "The Force",
  "Chance the Router",
  "Wu-Tang LAN",
  "Wi-Fight the Feeling",
  "A LANister Never Forgets",
  "May the Wi-Force Be With You",
  "Inigo the Modem",
  "Formerly Known as Prints",
  "Wi-Fight the Inevitable",
  "IanTernet",
  "Winternet is Coming",
  "Common Room Wifi",
  "Jar Jar Linksys",
  "Art Vandelay",
  "The Password is...",
  "House LANister",
  "Yer A Wifi Harry",
  "These Are Not the Droids You’re Looking For",
  "Never Gonna Give You Wifi",
  "H.E. Pennypacker",
  "Abraham Linksys",
  "Open Sesame",
  "For Whom the Belkin Tolls",
  "LANnisters Pay Their Debts",
  "Hagrid’s Hut",
  "A Long Time Ago…",
  "Chance the Router",
  "Silence of the LAN",
  "Every Day I’m Buffering",
  "RIP Net Neutrality",
  "LANnisters Send Their Regards",
  "Accio Internet",
  "MothersMaidenName",
  "John Wilkes Bluetooth",
  "Bandwidth Together",
  "Who What When Where WiFi",
  "You Shall Not Password",
  "Dumbledore's IT Staff",
  "I am WAN with the Web and the Web is with Me",
  "Password is Password",
  "Benjamin FrankLAN",
  "Lag Out Loud",
  "Wi Fi Fo Fum",
  "The Ping of the North",
  "Connecto Patronum",
  "Luke, I Am Your Wi-Fi",
  "Password is Gullible",
  "Alexander Graham Belkin",
  "No More Mister Wifi",
  "Hit the Road Jack Input",
  "And Don’t You Come Back",
  "No Mo No Mo No Mo No Mo",
  "JackPott",
  "The Mad Ping",
  "Squibs Only",
  "Forest Moon of Endor",
  "Theodore Routervelt",
  "No LAN for the Wicked",
  "Blind Sight",
  "Printer Only",
  "House of Black and Wifi",
  "Floo Network",
  "Docking Bay 94",
  "The LAN Down Under",
  "Franklin Delano Routervelt",
  "I Believe Wi Can Fi",
  "Daily Bread",
  "Comcasterly Rock",
  "Spread the Wealth",
  "Where the Wild Pings Are",
  "Now You See Me…",
  "Searching…",
  "Lord of the Ping",
  "Pretty Fly for a WiFi",
  "New England Clam Router",
  "Sweet Victory",
  "One if by LAN…",
  "One Wifi to Rule Them All",
  "Linksys Lohan",
  "Go Go Router Rangers",
  "Life on the Line",
  "AAAAAAAAAA",
  "Routers of Rohan",
  "Enter the Dragon’s Wifi",
  "Winona Router",
  "IP Steady Streams",
  "Cut the Wire",
  "Huge Tracts of LAN",
  "You Click, I Pay",
  "John Claude WAN Damme",
  "The Promised LAN",
  "FBI Channel 90210",
  "The Black Links",
  "Ludwig WAN Beethoven",
  "PorqueFi",
  "Since 1997",
  "FBI Van 13",
  "404 Network Unavailable",
  "Try Me",
  "Abraham WAN Helsing",
  "The LAN Before Time",
  "Surveillance Van",
  "Alt-255",
  "Full Bars",
  "LAN Halen",
  "Scooby-Doo, Where Are You?",
  "Witness Protection",
  "LAN Morrison",
  "LAN of Milk and Honey",
  "Final Fantasy Finally Finishes",
  "Tell My Wifi Love Her",
  "Unregistered Hypercam 2",
  "Bilbo Laggins",
  "The LAN of the Free",
  "Saved a Bunch of Money by Switching to GEICO",
  "It’s a Small World Wifi Internet",
  "Spiderman’s World Wide Web",
  "Do Re Mi Fa So La Wi Fi",
  "Lord Voldemodem",
  "Wifi Art Thou Romeo",
]
