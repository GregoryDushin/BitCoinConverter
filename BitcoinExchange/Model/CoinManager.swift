//
//  CoinManager.swift
//  BitcoinExchange
//
//  Created by Григорий Душин on 03.02.2022.
//

import Foundation
protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "25B0F4B3-47FB-460B-A96F-B21D3C54EF06"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //1.Create a URL
        if let url = URL(string: urlString) {
            //2.Create a URLSession
            
            let session = URLSession(configuration: .default)
            //3.Give the session the task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitCoinPrice = parsJSON(safeData) {
                        
                        let priceString = String(format: "%.2f", bitCoinPrice)
                        
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                    

                }
            }
            
            //4.Start the task
            
            task.resume()
        }
        
    }
    
    func parsJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
       let decodedData = try decoder.decode(CoinData.self, from: data)
           
            let lastPrise = decodedData.rate
            
            return lastPrise
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
}
}
