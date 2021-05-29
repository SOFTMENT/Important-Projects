//
//  CurrencyConverterViewController.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/14.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

protocol CurrencyConverterDisplayLogic: class {
    func displayInitialize(viewModel: CurrencyConverter.Initialize.ViewModel)
    func displayPerformExchange(viewModel: CurrencyConverter.PerformExchange.ViewModel)
}

class CurrencyConverterViewController: UIViewController {
    var interactor: CurrencyConverterBusinessLogic
    var router: (NSObjectProtocol & CurrencyConverterRoutingLogic & CurrencyConverterDataPassing)

  
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    lazy var collectionViewDataSource:
        UICollectionViewDiffableDataSource<Int, CurrencyConverter.DisplayedCurrencyResult> = {
        return createCollectionViewDataSource()
    }()
    
    var currencies: [CurrencyConverter.DisplayedCurrency] = []
    var selectedCurrency: CurrencyConverter.DisplayedCurrency?
    
    var actionSheet: UIAlertController?
    
    init() {
        
        
        let presenter = CurrencyConverterPresenter()
        let interactor = CurrencyConverterInteractor(presenter: presenter)
        let router = CurrencyConverterRouter(dataStore: interactor)
        self.interactor = interactor
        self.router = router
        
        super.init(nibName: String(describing: Self.self), bundle: nil)
        
        presenter.viewController = self
        router.viewController = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
           
           super.viewWillAppear(animated)
           
           var  color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
          
           let preferences = UserDefaults.standard

           let colorKey = "colorKey"

           if preferences.object(forKey: colorKey) == nil {
           
           } else {
               
               let currentLevel = preferences.string(forKey: colorKey)
               
               switch currentLevel {
               case "black":
                   color = UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
                   break;
                   
               case "green" :
                   color = UIColor.init(red: 22/255, green: 74/255, blue: 42/255, alpha: 1)
                   
                   break
                   
               case "red" :
                   color = UIColor.init(red: 237/255, green: 27/255, blue: 37/255, alpha: 1)
                   
                   break
               case "blue" :
                   color = UIColor.init(red: 34/255, green: 48/255, blue: 81/255, alpha: 1)
               
                   break
                   
               default:
                   print("")
               }
           }
           
           if #available(iOS 13.0, *) {
            
               let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
               let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
               
               let statusbarView = UIView()
               statusbarView.backgroundColor = color
               view.addSubview(statusbarView)
             
               statusbarView.translatesAutoresizingMaskIntoConstraints = false
               statusbarView.heightAnchor
                   .constraint(equalToConstant: statusBarHeight).isActive = true
               statusbarView.widthAnchor
                   .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
               statusbarView.topAnchor
                   .constraint(equalTo: view.topAnchor).isActive = true
               statusbarView.centerXAnchor
                   .constraint(equalTo: view.centerXAnchor).isActive = true
             
           } else {
               let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
               statusBar?.backgroundColor = color
           }
           
           
       }
       
    

    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            
        configHierachy()
        
    
        
        interactor.initilize(request: .init())
        
    }
    
    @IBAction func onTapCurrencyButton(_ sender: Any) {
        guard let actionSheet = actionSheet else { return }
        
        show(actionSheet, sender: nil)
    }
    
    @IBAction func onAmountChanged(_ sender: Any) {
        guard let text = amountTextField.text else { return }
        
        amountTextField.text = formatCalculatorNumberStyle(for: text)
        
        performExchange()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        amountTextField.resignFirstResponder()
    }
}

private extension CurrencyConverterViewController {
    func configHierachy() {
    //    lastUpdateLabel.text = nil
        
        collectionView.register(
            UINib(nibName: CurrencyResultCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: CurrencyResultCell.identifier)
        collectionView.collectionViewLayout = collectionViewLayout()
    }
    
    func createCollectionViewDataSource() ->
        UICollectionViewDiffableDataSource<Int, CurrencyConverter.DisplayedCurrencyResult> {
         return .init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, currency -> UICollectionViewCell? in
                let nullableCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CurrencyResultCell.identifier,
                    for: indexPath)
                guard let cell = nullableCell as? CurrencyResultCell else { return nil }
                
                cell.currencyLabel.text = currency.abbr
                cell.countryLabel.text = currency.full
                cell.convertedLabel.text = currency.amount
                cell.exchangeRateLabel.text = currency.rate
                
                return cell
        })
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnv -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(76.0)),
                subitem: item,
                count: layoutEnv.container.effectiveContentSize.width > 600 ? 2 : 1)
            group.interItemSpacing = .fixed(8)
            group.contentInsets = .init(top: 4, leading: 16, bottom: 4, trailing: 16)
            
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    func createActionSheet(
        from currencies: [CurrencyConverter.DisplayedCurrency],
        handler: @escaping (CurrencyConverter.DisplayedCurrency) -> Void) -> UIAlertController {
        let actionSheet = UIAlertController(
            title: "Select currency",
            message: nil,
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        currencies.forEach { currency in
            let action = UIAlertAction(title: currency.abbr, style: .default) { _ in handler(currency) }
            actionSheet.addAction(action)
        }
         
        return actionSheet
    }
    
    /// Convert the input number-convertible text or an empty text into a human readable format.
    /// - Parameter inputText: the text to be process.
    ///
    /// Examples:
    /// - "" -> "0"
    /// - ".123" -> "0.123"
    /// - "0000123" -> "123"
    func formatCalculatorNumberStyle(for inputText: String) -> String {
        var text = inputText
        
        if text.isEmpty { return "0" }
        
        if text.count > 1 {
            while text.count > 1, text.first == "0", text[text.index(text.startIndex, offsetBy: 1)] != "." {
                text = String(text.dropFirst())
            }
            
            if text.first == "." {
                text = "0\(text)"
            }
            
            return text
        }
        
        return text
    }
    
    func performExchange() {
        guard let selectedCurrency = selectedCurrency else { return }
        
        interactor.performExchange(request: .init(
            sourceCurrency: selectedCurrency.abbr,
            amount: Double(amountTextField.text ?? "") ?? 0))
    }
}

extension CurrencyConverterViewController: CurrencyConverterDisplayLogic {
    func displayInitialize(viewModel: CurrencyConverter.Initialize.ViewModel) {
        loadingIndicator.isHidden = true
        
        switch viewModel {
        case .failure:
            showOkAlert(title: "Error", message: "Could not fetch currencies data.", okTitle: "Reload") {
                self.loadingIndicator.isHidden = false
                self.interactor.initilize(request: .init())
            }
            
        case .success(let currencies):
            guard !currencies.isEmpty else { return }
            
            self.actionSheet = createActionSheet(from: currencies) { [weak self] currency in
                guard let self = self else { return }
                self.currencyButton.setTitle(currency.abbr, for: .normal)
                self.selectedCurrency = currency
                self.performExchange()
            }
            
            currencyButton.setTitle(currencies[0].abbr, for: .normal)
            self.selectedCurrency = currencies[0]
            performExchange()
        }
    }
    
    func displayPerformExchange(viewModel: CurrencyConverter.PerformExchange.ViewModel) {
        switch viewModel {
        case .failure:
            loadingIndicator.isHidden = true
            showOkAlert(title: "Error", message: "Could not fetch exchange rate.", okTitle: "Reload") {
                self.performExchange()
            }
            
        case .startFetchQuotes:
            loadingIndicator.isHidden = false
            
        case .successFetchQuotes( _):
            loadingIndicator.isHidden = true
          //  lastUpdateLabel.text = updateDate
            
        case .success(let currencies):
            var snapshot = NSDiffableDataSourceSnapshot<Int, CurrencyConverter.DisplayedCurrencyResult>()
            snapshot.appendSections([1])
            snapshot.appendItems(currencies)
            collectionViewDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension CurrencyConverterViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        guard amountTextField == textField else { return true }
        guard let oldText = textField.text else { return false }

        let newString = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        
        if newString.isEmpty {
            return true
        } else if newString.count > 10 {
            return false
        }
        
        return Double(newString) != nil
    }
}

extension UIViewController {
    func showOkAlert(title: String, message: String, okTitle: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in completion() }
        alert.addAction(ok)
        show(alert, sender: nil)
    }
}
