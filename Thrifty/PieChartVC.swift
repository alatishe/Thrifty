//
//  PieChartVC.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/16/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import Charts

class PieChartVC: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    //eventually just fill these arrays with the expense.type and percentage of expense
    let typeOfExpense = ["Food", "Shopping", "Gas", "Rent", "Transportation", "Entertainment"]
    let percentage = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPieChart(dataPoints: typeOfExpense, values: percentage)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPieChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "" )
        pieChartDataSet.sliceSpace = 2.0;
        
        pieChartDataSet.valueLinePart1OffsetPercentage = 0.8;
        //pieChartDataSet.valueLinePart1Length = 0.2;
        pieChartDataSet.valueLinePart2Length = 0.4;
        //dataSet.xValuePosition = .outsideSlice;
        pieChartDataSet.yValuePosition = .outsideSlice;
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        pieChartData.setValueFont(UIFont(name: "HelveticaNeue-Light", size: CGFloat(11.0)))
        pieChartData.setValueTextColor(UIColor.black)
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.6)
            colors.append(color)
        }
        pieChartView.data = pieChartData
        pieChartDataSet.colors = colors
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
