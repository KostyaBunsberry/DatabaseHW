//
//  WeatherVC.swift
//  hw14
//
//  Created by Kostya Bunsberry on 02.08.2020.
//

import UIKit
import RealmSwift

class TodayWeatherRealm: Object {
    @objc dynamic var temp: String = ""
    @objc dynamic var status: String = ""
}

class DayWeatherRealm: Object {
    @objc dynamic var weekDay: String = ""
    @objc dynamic var dayTemp: String = ""
    @objc dynamic var nightTemp: String = ""
}

class WeatherVC: UIViewController {
    
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let exampleDay: DayWeather = DayWeather(weekDay: "--", dayTemp: 0, nightTemp: 0)
    var dailyArray:[DayWeather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        let todayWeather = realm.objects(TodayWeatherRealm.self)
        let dailyWeather = realm.objects(DayWeatherRealm.self)
        
        if dailyWeather.count != 0 {
            for day in dailyWeather {
                dailyArray.append(DayWeather(weekDay: day.weekDay, dayTemp: Int(day.dayTemp)!, nightTemp: Int(day.nightTemp)!))
            }
        } else {
            for _ in 1..<7 {
                dailyArray.append(exampleDay)
            }
        }
        
        if todayWeather.count != 0 {
            self.weatherStatusLabel.text = todayWeather[0].status
            self.currentTempLabel.text = todayWeather[0].temp
        }
        
        SystemWeatherLoader().loadCurrentWeather( completition: { resultArray in
            self.weatherStatusLabel.text = resultArray[0] as? String
            self.currentTempLabel.text = "\(resultArray[1])°"
            
            if todayWeather.count == 0 {
                let firstTime = TodayWeatherRealm()
                
                try! realm.write {
                    realm.add(firstTime)
                }
            } else {
                try! realm.write {
                    todayWeather[0].status = resultArray[0] as! String
                    todayWeather[0].temp = "\(resultArray[1])°"
                }
            }
        })
        SystemWeatherLoader().loadDailyWeather(completition: { dailyArray in
            self.dailyArray = dailyArray
            
            let realm = try! Realm()
            
            try! realm.write {
                for object in realm.objects(DayWeatherRealm.self) {
                    realm.delete(object)
                }
                
                for day in dailyArray {
                    let newDay = DayWeatherRealm()
                    newDay.weekDay = day.weekDay
                    newDay.dayTemp = String(day.dayTemp)
                    newDay.nightTemp = String(day.nightTemp)
                    
                    realm.add(newDay)
                }
            }
            self.tableView.reloadData()
        })
        
    }
}

extension WeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDailyCell") as! DayWeatherCell
        
        cell.dayNameLabel.text = dailyArray[indexPath.row].weekDay
        cell.dayTempLabel.text = "\(dailyArray[indexPath.row].dayTemp)"
        cell.nightTempLabel.text = "\(dailyArray[indexPath.row].nightTemp)"
        
        return cell
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension NSDate {
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
}
