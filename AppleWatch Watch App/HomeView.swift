//
//  HomeView.swift
//  AppleWatch Watch App
//
//  Created by ST SE on 17/3/2023.
//

import SwiftUI
import WatchKit

struct HomeView: View {
  @State var money: Int = 0
  @State private var action = 0
  @State private var selectedNumber = 0
  @State private var presentAlert = false

  var body: some View {
    var numbers = money > 0 ? Array(1...money) : []

    NavigationView {
      VStack {
        Text("你的金錢： \(money)")
          .font(.title3)
          .foregroundColor(.white)
          .padding(.top, 10)
        HStack {
          VStack {
            Picker("滾動輸入賭注", selection: $selectedNumber) {
              ForEach(numbers, id: \.self) { number in
                Text("\(number)")
              }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 60)
            .padding(.bottom)
          }

          VStack {
            Spacer()
            Button(action: {
              presentAlert = true
            }) {
              Text("課金")
            }

            .frame(width: 55, height: 40)
            .fontWeight(.semibold)
            .background(Color.green)
            .cornerRadius(15)
            .alert(
              "付款成功", isPresented: $presentAlert,
              actions: {
                Button(action: {
                  money += 40
                  UserDefaults.standard.set(money, forKey: "money")
                }) {
                  Text("確認")
                }
              },
              message: {
                Text("\n\n\n即將為你增值: $ 40")
              })

          }
        }
          
          if money == 0{
              
              NavigationLink(destination: ContentView(money: money, Selectmoney: selectedNumber)) {
                  Text("請增值!")
                }
              .disabled(true)
              
          } else {
              
              NavigationLink(destination: ContentView(money: money, Selectmoney: selectedNumber)) {
                  Text("加入賭注!")
              }.simultaneousGesture(TapGesture().onEnded{
                  money -= selectedNumber
                  UserDefaults.standard.set(money, forKey: "money")
                  print("Starting game!")
              })
          }
        
          
          

      }
      .navigationTitle("猜數字遊戲")

    }
    .onAppear {
      money = CheckMoney()

    }
    .onDisappear {
      print("------saved--------------")
      UserDefaults.standard.set(money, forKey: "money")
    }
  }

  func CheckMoney() -> Int {
    if let savedMoney = UserDefaults.standard.object(forKey: "money")
      as? Int, savedMoney > 0
    {
      print("-----loading the money------")
      return savedMoney
    } else {
      UserDefaults.standard.set(0, forKey: "money")
      return 0
    }
  }
}
