//
//  ContentView.swift
//  AppleWatch Watch App
//
//  Created by ST SE on 16/3/2023.
//

import SwiftUI
import WatchKit

struct ContentView: View {

  @State private var selectedNumber = 50
  @State private var randomNumber = Int.random(in: 1...100)
  @State private var presentAlert = false
  @State private var remainingGuesses = 5
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State var money: Int
  @State var Selectmoney: Int
  @State var backFlag = false
  @State private var maxNum = 100
  @State private var minNum = 1


  @Environment(\.presentationMode) var presentationMode

  let numbers = Array(1...100)

  var body: some View {
    NavigationView {
      VStack {

        Text("猜數字遊戲")
          .font(.title2)
          .foregroundColor(.white)
          .padding()

        Picker("滾動輸入數字", selection: $selectedNumber) {
          ForEach(numbers, id: \.self) { number in
            Text("\(number)")
          }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(width: 100)
        .padding(.bottom)

        Button(
          action: {
            presentAlert = true
            checkGuess(num: selectedNumber)
          },
          label: {
            Text("ok")
          }
        )
        .frame(width: 150, height: 20)
        .padding(10)
        .alert(
          "\(alertTitle) \n\n \(alertMessage)", isPresented: $presentAlert,
          actions: {
            Button(action: {
              if backFlag == true {
                restart()
              }
            }) {
              Text("確認")
            }
          })
      }
    }
  }
  func checkGuess(num: Int) {
    if num == randomNumber {
      alertTitle = "恭喜你！"
      alertMessage = "你猜中了！ 答案是 \(randomNumber) \n 你額外贏得了$ \(Selectmoney)"
      money = money + (Selectmoney * 2)
      print("WIN! current money : \(money), bet : \(Selectmoney)")
      UserDefaults.standard.set(money, forKey: "money")
      backFlag = true
    } else {
      remainingGuesses -= 1
      if remainingGuesses == 0 {
        alertTitle = "遊戲結束"
        alertMessage = "你沒有猜中。答案是 \(randomNumber) \n 你失去了$ \(Selectmoney)"
        
          print("LOSE! current money : \(money), bet : \(Selectmoney)")
        UserDefaults.standard.set(money, forKey: "money")
        
        print("Checking Database ... The money is \(UserDefaults.standard.object(forKey: "money"))")
        backFlag = true

      } else if num < randomNumber {
        minNum = num
        alertTitle = "剩餘猜測次數: \(remainingGuesses)"
        alertMessage = "請再猜一個大一點的數字: \n \(minNum) - \(maxNum)"

      } else {
        maxNum = num
        alertTitle = "剩餘猜測次數: \(remainingGuesses)"
        alertMessage = "請再猜一個小一點的數字: \n \(minNum) - \(maxNum)"

      }
    }
  }
  func restart() {
    remainingGuesses = 5
    randomNumber = Int.random(in: 1...100)

    self.presentationMode.wrappedValue.dismiss()
  }

}
