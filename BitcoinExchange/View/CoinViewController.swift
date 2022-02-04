//
//  ViewController.swift
//  BitcoinExchange
//
//  Created by Григорий Душин on 03.02.2022.
//

import UIKit

class CoinViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
    }
}
//MARK:- CoinManagerDelegate
extension CoinViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
             self.bitcoinLabel.text = price
             self.currencyLabel.text = currency
         }
     }
     
     func didFailWithError(error: Error) {
         print(error)
     }
    }
//MARK:- UIPickerViewDataSource
extension CoinViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
}
//MARK:- UIPickerViewDelegate
extension CoinViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return coinManager.currencyArray[row]
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedCurrency = coinManager.currencyArray[row]
    
                    coinManager.getCoinPrice(for: selectedCurrency)
        }
}
