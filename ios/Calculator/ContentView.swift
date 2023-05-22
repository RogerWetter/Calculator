//
//  ContentView.swift
//  Calculator
//
//  Created by roger wetter on 21.04.23.
//

import SwiftUI

enum Operators: String {
    case clear = "AC", convert = "⁺∕₋", percent = "%", divide = "÷", multiply = "×", minus = "−", plus = "+", equals = "=", dot = "."
}

struct ContentView: View {
    let buttons = [
        [Operators.clear.rawValue, Operators.convert.rawValue, Operators.percent.rawValue, Operators.divide.rawValue],
        ["7", "8", "9", Operators.multiply.rawValue],
        ["4", "5", "6", Operators.minus.rawValue],
        ["1", "2", "3", Operators.plus.rawValue],
        ["0", Operators.dot.rawValue, Operators.equals.rawValue]
    ]
    
    @State var currentNumberString: String = "0"
    @State var currentNumber: Double = 0
    @State var storedNumber: Double?
    @State var operation: String?
    @State var dotSet: Int = 0
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(currentNumberString)
                .font(.system(size: 100))
                .fontWeight(.light)
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal, 30.0)
                .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                .background(Color.black)
                .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .global)
                    .onEnded({ value in
                        if (value.translation.width > 50 || value.translation.width < -50) {
                            deleteLastNumber()
                        }
                    })
                )
                
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.buttonTapped(button)
                        }) {
                            Text(button)
                                .font(.system(size: self.buttonTextSize(button)))
                                .fontWeight(self.buttonTextWeight(button))
                                .frame(width: self.buttonWidth(button), height: self.buttonHeight())
                                .foregroundColor(self.buttonForeground(button))
                                .background(self.buttonBackground(button))
                                .cornerRadius(self.buttonHeight() / 2)
                        }
                    }
                }
            }
        }
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/)
    }
    
    func buttonTapped(_ button: String) {
        switch button {
        case Operators.clear.rawValue:
            currentNumber = 0
            updateString()
            dotSet = 0
            storedNumber = nil
            operation = nil
        case Operators.convert.rawValue:
            currentNumber = currentNumber * -1
            updateString()
        case Operators.percent.rawValue:
            currentNumber = currentNumber / 100
            updateString()
        case Operators.plus.rawValue, Operators.minus.rawValue, Operators.multiply.rawValue, Operators.divide.rawValue:
            storedNumber = currentNumber
            currentNumber = 0
            operation = button
        case Operators.equals.rawValue:
            switch operation {
            case Operators.plus.rawValue:
                currentNumber = storedNumber! + currentNumber
            case Operators.minus.rawValue:
                currentNumber = storedNumber! - currentNumber
            case Operators.multiply.rawValue:
                currentNumber = storedNumber! * currentNumber
            case Operators.divide.rawValue:
                if currentNumber != 0 {
                    currentNumber = storedNumber! / currentNumber
                }
            default:
                return
            }
            updateString()
            storedNumber = nil
            operation = nil
        default:
            if button == Operators.dot.rawValue {
                if (dotSet == 0) {
                    dotSet = 1
                    currentNumberString += "."
                    return
                }
            }
            else if let number = Double(button) {
                if (dotSet > 0) {
                    if (dotSet > 8) {return}
                    currentNumber += number * pow(10, Double(-dotSet))
                    dotSet += 1
                } else {
                    if currentNumber < 10e10 {
                        currentNumber = currentNumber * 10 + number
                    }
                }
            }
            updateString()
        }
    }
    
    func deleteLastNumber() {
        if (currentNumber == 0) { print("currentnumber = 0"); return }
        if (dotSet > 0) {
            dotSet -= 1
            if (dotSet != 0) {
                let x = pow(10, Double(-(dotSet-1)))
                let lastnumb = currentNumber.truncatingRemainder(dividingBy: pow(10, Double(-(dotSet-1))))
                currentNumber = currentNumber - lastnumb
                if (dotSet == 1) {
                    updateString()
                    currentNumberString += "."
                    return
                }
            }
        } else {
            let lastnumb = Int(currentNumber) % 10
            currentNumber = (currentNumber - Double(lastnumb)) / 10
        }
        updateString()
    }
    
    func updateString() {
        currentNumber = (currentNumber * 1e9).rounded() / 1e9
        if currentNumber < 10e8 {
            print(currentNumber)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "'"
            formatter.maximumFractionDigits = 8
            currentNumberString = formatter.string(for: currentNumber) ?? "Error"
        } else {
            currentNumberString = String(format: "%.2e", currentNumber)
        }
        
    }
    
    func buttonWidth(_ button: String) -> CGFloat {
        if button == "0" {
            return (UIScreen.main.bounds.width - 3 * 10) / 2
        }
        return (UIScreen.main.bounds.width - 5 * 10) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 10) / 4
    }
    
    func buttonForeground(_ button: String) -> Color {
        switch button {
        case Operators.clear.rawValue, Operators.convert.rawValue, Operators.percent.rawValue:
            return Color.black
        default:
            return Color.white
        }
    }
    
    func buttonBackground(_ button: String) -> Color {
        switch button {
        case Operators.clear.rawValue, Operators.convert.rawValue, Operators.percent.rawValue:
            return Color.gray
        case Operators.plus.rawValue, Operators.minus.rawValue, Operators.multiply.rawValue, Operators.divide.rawValue, Operators.equals.rawValue:
            return Color.orange
        default:
            return Color(red: 63/255, green: 63/255, blue: 63/255)
        }
    }
    
    func buttonTextSize(_ button: String) -> CGFloat {
        switch button {
        case Operators.clear.rawValue, Operators.convert.rawValue, Operators.percent.rawValue:
            return 35
        case Operators.plus.rawValue, Operators.minus.rawValue, Operators.multiply.rawValue, Operators.divide.rawValue, Operators.equals.rawValue:
            return 50
        default:
            return 40
        }
    }
    
    func buttonTextWeight(_ button: String) -> Font.Weight {
        switch button {
        case Operators.clear.rawValue, Operators.convert.rawValue, Operators.percent.rawValue:
            return .medium
        case Operators.plus.rawValue, Operators.minus.rawValue, Operators.multiply.rawValue, Operators.divide.rawValue, Operators.equals.rawValue:
            return .medium
        default:
            return .regular
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
