//
//  ExercisesViewController.swift
//
//
//  Created by Andrei Mirzac on 23/12/2020.
//

import UIKit
import ReSwift

class ExercisesViewController: UIViewController {
    private enum Section: CaseIterable {
        case main
    }

    private var spinner: UIActivityIndicatorView?
    private var store: Store<ExerciseListState>

    private typealias DataSource = UICollectionViewDiffableDataSource<ExercisesViewController.Section, Exercise>
    private var dataSource: DataSource?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        return collectionView
    }()

    func compositionalLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.backgroundColor = .systemBackground
        layoutConfig.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: FilterEquipment.allCases.map({ $0.rawValue.capitalized } ))
        segmentControl.addTarget(self, action: #selector(selectFilterAction), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()

    init(store: Store<ExerciseListState>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        addContraintsToCollectionView()
    }

    @objc func selectFilterAction(sender: UISegmentedControl) {
        guard let title = sender.titleForSegment(at: sender.selectedSegmentIndex) else {
            fatalError("Unable to cast selectedSegmentIndex to Equipment")
        }

        guard let filter = FilterEquipment(rawValue: title) else {
            fatalError("Unable to cast selectedSegmentIndex to Equipment")
        }

        store.dispatch(ExercisesAction.set(filter: filter))
        store.dispatch(fetchExercises())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView =  segmentControl
        createDataSource()
        store.subscribe(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.dispatch(fetchExercises())
    }

    private  func addContraintsToCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
    }
    
    private func createDataSource() {
        collectionView.register(ExerciseViewCell.self, forCellWithReuseIdentifier: ExerciseViewCell.reuseIdentifier)
        dataSource = DataSource (collectionView: collectionView) { collectionView, indexPath, exercise in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseViewCell.reuseIdentifier, for: indexPath) as? ExerciseViewCell else {
                fatalError("Unable to dequeue \(ExerciseViewCell.self)")
            }
            cell.setup(exercise: ExerciseViewData.map(from: exercise))
            return cell
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration
        <SupplimentaryViewCell>(elementKind: UICollectionView.elementKindSectionFooter) {
            (footerView, elementKind, indexPath) in
        }

        dataSource?.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let view = self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
            self.spinner = view.spinner
            return view
        }
    }
    
    private func reloadData(_ exercises: [Exercise]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Exercise>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(exercises, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot)
        }

    }
}

extension ExercisesViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = ExerciseListState

    func newState(state: ExerciseListState) {
        switch state.paging?.state {
        case .failure(let error):
            showAlert(error: error)
        default:
            break
        }
        
        reloadData(state.paging?.values ?? [])
        state.isLoading ? spinner?.startAnimating() : spinner?.stopAnimating()
    }
}

extension ExercisesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == store.state.exercises.count - 2 {
            store.dispatch(fetchExercises())
        }
    }
}
