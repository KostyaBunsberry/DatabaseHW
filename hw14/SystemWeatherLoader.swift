//
//  SystemWeatherLoader.swift
//  hw14
//
//  Created by Kostya Bunsberry on 07.08.2020.
//

import Foundation

struct DayWeather {
    let weekDay: String
    let dayTemp: Int
    let nightTemp: Int
}

class SystemWeatherLoader {
    
    func loadCurrentWeather(completition: @escaping ([AnyHashable]) -> Void) {
        print("Current: Started loading")
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=5fb7901e9f3cdc6cc79532e37782e3f7")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
                print("Current: Unwrapped JSON")
                
                if let weatherArray = jsonDict["weather"] as? NSArray,
                   let weather = weatherArray[0] as? NSDictionary,
                   let main = jsonDict["main"] as? NSDictionary {
                    
                    var weatherText = weather["description"] as! String
                    weatherText.capitalizeFirstLetter()
                    
                    var tempDouble = main["temp"] as! Double
                    tempDouble -= 273.0
                    let tempInt = Int(tempDouble)
                    print(tempInt)
                    
                    DispatchQueue.main.async {
                        print("Current:  result sent")
                        let resultArray: [AnyHashable] = [weatherText, tempInt]
                        completition(resultArray)
                    }
               }
            }
        }
        task.resume()
    }
    
    func loadDailyWeather(completition: @escaping ([DayWeather]) -> Void) {
        print("Daily: Started Loading")
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=55.75&lon=37.62&exclude=current,hourly&appid=5fb7901e9f3cdc6cc79532e37782e3f7")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary,
               let dailyArray = jsonDict["daily"] as? NSArray {
                
                var daysArray: [DayWeather] = []
                
                for (_, day) in dailyArray.enumerated() {
                    if let dayData = day as? NSDictionary,
                       let date = dayData["dt"] as? Double,
                       let dayTempDict = dayData["temp"] as? NSDictionary {
                        var dayTempDouble = dayTempDict["day"] as! Double
                        dayTempDouble -= 273.0
                        let dayTemp = Int(dayTempDouble)
                        
                        var nightTempDouble = dayTempDict["night"] as! Double
                        nightTempDouble -= 273.0
                        let nightTemp = Int(nightTempDouble)
                        
                        let weekDay = NSDate(timeIntervalSince1970: date).dayOfTheWeek()!
                        let day = DayWeather(weekDay: weekDay, dayTemp: dayTemp, nightTemp: nightTemp)
                        daysArray.append(day)
                    }
                }
                
                daysArray.remove(at: 0)
                
                DispatchQueue.main.async {
                    print("Daily: Result Sent")
                    completition(daysArray)
                }
            }
        }
        task.resume()
    }
    
}
