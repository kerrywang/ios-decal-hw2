//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    var curNum=String()
    var prevNum=String()
    var oper=String()
    var shoudlCal = false
    var justOper = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
        someDataStructure.append(content)
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Update me like one of those PCs")
        if content.characters.count>7{
            let targetIndex=content.index(content.startIndex,offsetBy:7)
            resultLabel.text=content.substring(to: targetIndex)
        }
        else{
            resultLabel.text=content}
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        
        return calculate(a: prevNum, b: resultLabel.text!, operation: oper)
        
        
    }
    
    /* TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> String {
        print("Calculation requested for \(a) \(operation) \(b)")
        var result:Double
        switch operation{
        case "-":  result = a-b
        case "+":  return String(a+b)
        case "*":  return String(a*b)
        case "/":  return String(a/b)
        default: return "0"
        }
    }*/
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> String {
        print("Calculation requested for \(a) \(operation) \(b)")
        let c=Double(a)!
        let d=Double(b)!
        var result:Double
        switch operation{
        case "-":  result = c-d
        case "+":  result = c+d
        case "*":  result = c*d
        case "/":  result = c/d
        default: return ""
        }
        if (result > 1e6||result < -1e6||(result < 1e-5&&result > -1e-5))
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle=NumberFormatter.Style.scientific
            numberFormatter.positiveFormat = "0.000E0"
            numberFormatter.negativeFormat="-0.000E0"
            numberFormatter.exponentSymbol = "e"
            numberFormatter.maximumSignificantDigits=3
            return numberFormatter.string(from: result as NSNumber)!
        }
        else{
            let numberFormatter = NumberFormatter()
            numberFormatter.positiveFormat = "0.000E0"
            numberFormatter.negativeFormat="-0.000E0"
            numberFormatter.exponentSymbol = "e"

            numberFormatter.numberStyle=NumberFormatter.Style.decimal
            numberFormatter.maximumSignificantDigits=6
        if result.truncatingRemainder(dividingBy: 1)==0 {return String(Int(result))}
        else{return String(result)}
        }
        
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        // Fill me in
        updateSomeDataStructure(sender.content)
        var result=resultLabel.text!
        if result=="0"||justOper {result=sender.content; justOper=false}
        else{
            result.append(sender.content)}
        updateResultLabel(result)
    }
    func isOperator(oper:String)->Bool
    {
        if (oper=="+"||oper=="-"||oper=="*"||oper=="/")
        {
            return true
        }
        return false
    }
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        if(sender.content=="C"){
            someDataStructure=[]
            resultLabel.text="0"
            prevNum=""
            shoudlCal=false
        }
        if(sender.content=="+/-"){
            let result=Double(resultLabel.text!)
            if(result!.truncatingRemainder(dividingBy: 1)==0){updateResultLabel(String(-1*Int(result!)))}
            else{
                updateResultLabel(String(-1*result!))
            }
        }
        if isOperator(oper: sender.content){
            justOper=true
            if prevNum.isEmpty{
                prevNum=resultLabel.text!
                oper=sender.content
                print("first round")
            }
            else{
                if isOperator(oper: someDataStructure[someDataStructure.count-1]){
                    oper=sender.content
                    print("sec round")

                }
                else{
                    let result=calculate()
                    print("\(result) is the fking result")

                    updateResultLabel(result)
                    prevNum=result
                    someDataStructure=[result]
                    oper=sender.content

                }
            }
            updateSomeDataStructure(sender.content)
        }
        if (sender.content=="="){
            if(!prevNum.isEmpty){
                let result = calculate()
                prevNum=""
                updateResultLabel(result)
                justOper=true
                someDataStructure=[result]
            }
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
        var result = resultLabel.text!
        if(sender.content=="."){
            if justOper{
                updateResultLabel("0.")
                updateSomeDataStructure("0")
                justOper=false}
            else{
                result.append(".")
                updateResultLabel(result)
                updateSomeDataStructure("0")}
        }
        if(sender.content=="0"){
            if result != "0"{
                if justOper{
                    updateResultLabel("0")
                    updateSomeDataStructure("0")
                    justOper=false}
                else{
                result.append("0")
                updateResultLabel(result)
                updateSomeDataStructure("0")}
            }
        }

    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

