//
//  ContentView.swift
//  Bullseye
//
//  Created by Michael Chen on 8/17/20.
//  Copyright © 2020 Michael Chen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    /*use to indicate when a state has changed, whenever a state variable is change the body is refreshed
     */
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    let midnightBlue = Color(red: 0.0/255.0, green: 51.0/255.0, blue: 102.0/255.0)
    
    struct LabelStyle : ViewModifier{
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.white)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ButtonLargeTextStyle : ViewModifier{
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ButtonSmallTextStyle : ViewModifier{
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
        }
    }
    
    struct ValueStyle : ViewModifier{
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
        }
    }
    
    struct Shadow : ViewModifier{
        func body(content: Content) -> some View {
            return content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            //Target row
            HStack {
                Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                Text("\(target)").modifier(ValueStyle())
                
            }
            Spacer()  //create space between views
            
            //Slider row
            HStack{
                Text("1").modifier(LabelStyle())
                Slider(value: $sliderValue, in: 1...100).accentColor(Color.green)
                Text("100").modifier(LabelStyle())
            }
            Spacer()
            
            /*Button Row
             action is what happen when button pressed
             */
            Button(action: {
                print("Button pressed!")
                //when this happens, "body" is automatically refreshed
                self.alertIsVisible = true
            }) {
                Text(/*@START_MENU_TOKEN@*/"Hit Me!"/*@END_MENU_TOKEN@*/).modifier(ButtonLargeTextStyle())
                //alert will checked the value of alertIsVisible and if true perform a alert
            }.alert(isPresented: $alertIsVisible) { () -> Alert in
                return Alert(title: Text(alertTitle()), message: Text("The slider's value is \(sliderValueRounded()).\n" +
                    "You scored \(pointsForCurrentRound()) points this round"), dismissButton: .default(Text("Awesome!")){
                        //score and new target won't be updated until after ""
                        self.score = self.score + self.pointsForCurrentRound()
                        self.target = Int.random(in: 1...100)
                        self.round += 1
                    })
            }.background(Image("Button"), alignment: .center).modifier(Shadow())
            Spacer()
            
            //Score row
            HStack{
                Button(action: {
                    self.startNewGame()
                }) {
                    HStack {
                        Image("StartOverIcon")
                        Text("Start Over").modifier(ButtonSmallTextStyle())
                    }
                }.background(Image("Button"), alignment: .center).modifier(Shadow())
                Spacer()
                Text("Score:").modifier(LabelStyle())
                Text("\(score)").modifier(ValueStyle())
                Spacer()
                Text("Round:").modifier(LabelStyle())
                Text("\(round)").modifier(ValueStyle())
                Spacer()
                NavigationLink(destination: AboutView()) {
                    HStack {
                        Image("InfoIcon")
                        Text("Info").modifier(ButtonSmallTextStyle())
                    }
                }.background(Image("Button"), alignment: .center).modifier(Shadow())
            }.padding(.bottom, 20)
        }.background(Image("Background"), alignment: .center).accentColor(midnightBlue).navigationBarTitle("Bullseye")
    }
    
    func sliderValueRounded() -> Int{
        return Int(sliderValue.rounded())
    }
    
    func amountOff() -> Int {
        abs(target - sliderValueRounded())
    }
    
    func pointsForCurrentRound() -> Int {
        let maximumScore = 100
        let difference = amountOff()
        
        let bonus: Int
        if difference == 0{
            bonus = 100
        }
        else if difference == 1 {
            bonus = 50
        }
        else {
            bonus = 0
        }
        return maximumScore - difference + bonus
    }
    
    func alertTitle() -> String {
        let difference = amountOff()
        let title: String
        
        if difference == 0{
            title = "Perfect!"
        }
        else if difference < 5 {
            title = "You almost had it"
        }
        else if difference <= 10 {
            title = "Not bad"
        }
        else{
            title = "Are you even trying?"
        }
        
        return title
    }
    
    func startNewGame(){
        score = 0
        round = 1
        sliderValue = 50.0
        target = Int.random(in: 1...100)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //make preview show in landscape mode
        ContentView().previewLayout(.fixed(width: 812, height: 375))
    }
}
