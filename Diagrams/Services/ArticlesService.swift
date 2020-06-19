//
//  ArticlesService.swift
//  Diagrams
//
//  Created by Ihor Pedan on 25.12.2019.
//  Copyright © 2019 Ihor Pedan. All rights reserved.
//

import Foundation
import News

protocol ArticlesServiceInput {
  func countArticlesStatistics(handler: @escaping (ArticlesStatistics) -> Void)
}

struct ArticlesStatistics {
  static var zero: ArticlesStatistics {
    return .init(apple: 0, bitcoin: 0, nginx: 0)
  }

  let apple: Int
  let bitcoin: Int
  let nginx: Int
  
  var array: [Int] { [apple, bitcoin, nginx] }
}

class ArticlesService: ArticlesServiceInput {
  
  private let apiKey = "a9b0a70b40c7497fae2f6cff41567103"
  
  var fromDate: Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month], from: Date())
    guard var month = components.month else { return Date() }
    switch month {
    case 0, 1:
      month = 12
      break
    default:
      month = month - 1
    }
    return calendar.date(bySetting: .month, value: month, of: Date()) ?? Date()
  }
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-DD"
    return formatter
  }()
  
  func countArticlesStatistics(handler: @escaping (ArticlesStatistics) -> Void) {
    let fromDate = dateFormatter.string(from: self.fromDate)
    var appleCount: Int = 0
    var bitcoinCount: Int = 0
    var nginxCount: Int = 0
    
    let group = DispatchGroup()
    
    group.enter()
    ArticlesAPI.everythingGet(q: "apple", from: fromDate, sortBy: "publishedAt", apiKey: apiKey) { (list, error) in
      if list != nil {
        appleCount = list!.totalResults ?? 0
      } else if error != nil {
        print("News apple failed")
        print(error!.localizedDescription)
        print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
      }
      group.leave()
    }

    group.enter()
    ArticlesAPI.everythingGet(q: "bitcoin", from: fromDate, sortBy: "publishedAt", apiKey: apiKey) { (list, error) in
      if list != nil {
        bitcoinCount = list!.totalResults ?? 0
      } else if error != nil {
        print("News bitcoin failed")
        print(error!.localizedDescription)
        print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
      }
      group.leave()
    }

    group.enter()
    ArticlesAPI.everythingGet(q: "nginx", from: fromDate, sortBy: "publishedAt", apiKey: apiKey) { (list, error) in
      if list != nil {
        nginxCount = list!.totalResults ?? 0
      } else if error != nil {
        print("News nginx failed")
        print(error!.localizedDescription)
        print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
      }
      group.leave()
    }

    group.notify(queue: .main) {
      handler(.init(apple: appleCount, bitcoin: bitcoinCount, nginx: nginxCount))
    }
  }
}
