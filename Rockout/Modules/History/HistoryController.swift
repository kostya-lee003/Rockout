//
//  HistoryController.swift
//  Rockout
//
//  Created by Kostya Lee on 26/05/24.
//

import Foundation
import UIKit
import SnapKit
import CoreData

@available(iOS 16.0, *)
public class HistoryController: UIViewController, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
    private let calendarView = UICalendarView()
    private var decorationDays = [Int]()
    private let calendar = Calendar.current
    private let formatter = DateFormatter()

    public override func viewDidLoad() {
        initViews()
        handleVisibleMonthChange(dateComponents: calendarView.visibleDateComponents)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }

    public func initViews() {
        self.title = "История тренировок"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white

        let w = self.view.frame.width
        let h = self.view.frame.height / 2
        let x = 0.0
        let y = self.view.centerY - h/2
        calendarView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        calendarView.overrideUserInterfaceStyle = .light
        calendarView.backgroundColor = .white
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        calendarView.delegate = self
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection

        self.view.addSubview(calendarView)
    }
    
    public func layout() {
        
    }
    
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let dayNumber = dateComponents.day, decorationDays.contains(dayNumber) {
            return .default(color: .red)
        }
        return nil
    }

    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let date = dateComponents?.date {
            let vc = HistoryDayController(date: date)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    let f = DateFormatter()
    public func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        handleVisibleMonthChange(dateComponents: calendarView.visibleDateComponents)
    }

    private func handleVisibleMonthChange(dateComponents: DateComponents) {
        if let year = dateComponents.year, let month = dateComponents.month {
            print("Displayed month changed to: \(year)-\(month)")
            if let dateRange = self.getDateRange(for: dateComponents) {
                
                print("Visible date range: \(dateRange.start) to \(dateRange.end)")
                
                configureDecorationDays(
                    start: dateRange.start,
                    end: dateRange.end
                )
            }
        }
    }
    
    private func getDateRange(for dateComponents: DateComponents) -> (start: Date, end: Date)? {
        
        // Get the first day of the month
        var startComponents = dateComponents
        startComponents.day = 2

        // Get the range of days in the month
        guard let startDate = calendar.date(from: startComponents),
              let range = calendar.range(of: .day, in: .month, for: startDate),
              let endDate = calendar.date(byAdding: .day, value: range.count - 1, to: startDate) else {
            return nil
        }
        
        return (start: startDate, end: endDate)
    }
    
    // Converts DateInterval to Array of Date
    public func rangeToArray(_ range: DateInterval) -> [Date] {
        var dates = [Date]()
        
        var startDate = range.start // first date
        let endDate = range.end // last date
        
        print("Configuring from \(f.string(from: startDate)) to \(f.string(from: endDate))")

        while startDate <= endDate {
            dates.append(startDate)
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }
        
        return dates
    }
    
    public func configureDecorationDays(
        start: Date,
        end: Date
//        completion: (([Int]) -> Void)?
    ) {
        self.decorationDays = []
        let backgroundContext = CoreDataManager.shared.backgroundContext
        backgroundContext.perform { [weak self] in
            guard let self else { return }

            let startDate = start
            let endDate = end
            
            let predicate = NSPredicate(
                format: "date >= %@ AND date < %@",
                startDate as NSDate,
                endDate as NSDate
            )
            let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let results = try CoreDataManager.shared.context.fetch(fetchRequest)
                let days = results.compactMap({
                    Calendar.current.dateComponents([.day], from: $0.date ?? Date()).day
                })
                DispatchQueue.main.async {
                    self.decorationDays = days
                    let components = results.compactMap {
                        if let date = $0.date {
                            return Calendar.current.dateComponents([.day, .month, .year], from: date)
                        } else {
                            return nil
                        }
                    }
                    self.calendarView.reloadDecorations(
                        forDateComponents: removeDuplicates(from: components),
                        animated: true
                    )
                }
            } catch {
                CoreDataManager.shared.logFetchEntityError(
                    methodName: #function,
                    className: String(describing: self)
                )
                self.decorationDays = []
                calendarView.reloadDecorations(forDateComponents: [], animated: true)
            }
        }
    }
}
