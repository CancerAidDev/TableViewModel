import Foundation
import UIKit

public class TableViewModel: NSObject, UITableViewDataSource {

    public let tableView: UITableView
    public var sectionAnimation: UITableViewRowAnimation

    internal var sections: NSMutableArray

    public init(tableView: UITableView) {
        self.sections = NSMutableArray()
        self.tableView = tableView
        self.sectionAnimation = UITableViewRowAnimation.Fade

        super.init()

        self.tableView.dataSource = self;

        addObserver(self, forKeyPath: "sections", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "sections")
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let indexSet: NSIndexSet = change?[NSKeyValueChangeIndexesKey] as! NSIndexSet else {
            return
        }

        guard let kind: NSKeyValueChange = NSKeyValueChange(rawValue: change?[NSKeyValueChangeKindKey] as! UInt) else {
            return
        }

        self.tableView.beginUpdates()
        switch kind {
        case .Insertion:
            tableView.insertSections(indexSet, withRowAnimation: self.sectionAnimation)
        case .Removal:
            tableView.deleteSections(indexSet, withRowAnimation: self.sectionAnimation)
        default:
            return
        }
        tableView.endUpdates()
    }

    public func addSection(section: TableSection) {
        observableSections().addObject(section)
    }

    public func removeSection(section: TableSection) {
        observableSections().removeObject(section)
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    private func observableSections() -> NSMutableArray {
        return mutableArrayValueForKey("sections")
    }
}
