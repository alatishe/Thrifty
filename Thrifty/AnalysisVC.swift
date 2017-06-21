//
//  AnalysisVC.swift
//  Thrifty
//
//  Created by Roslyn Lu on 6/14/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import Charts

class AnalysisVC: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    //eventually just fill these arrays with the expense.type and percentage of expense
    let typeOfExpense = ["Food", "Shopping", "Gas", "Rent", "Transportation", "Entertainment"]
    let percentage = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    //for line chart
    let date : [Double] = [1, 2, 3, 4, 5, 6, 7]
    let expenses : [Double] = [1, 2, 3, 4, 5, 6, 7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setPieChart(dataPoints: typeOfExpense, values: percentage)
        setLineChart(date: date, expenses: expenses)
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
        //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
        pieChartDataSet.yValuePosition = .outsideSlice;
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        //DefaultValueFormatter.swift, parameter is of type NumberFormatter. DefaultValueFormatter is of type NSObject, IValueFormatter
        let ivitem : IValueFormatter = DefaultValueFormatter(formatter: pFormatter)
        //setValueFormatter is in file ChartData.swift, parameter is of type IValueFormatter
        pieChartData.setValueFormatter(ivitem)
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
    
    func setLineChart(date: [Double], expenses: [Double])
    {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<date.count {
            let dataEntry = ChartDataEntry(x: date[i], y: expenses[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Expenses")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    
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
