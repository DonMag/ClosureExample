//
//  ViewController.swift
//  ClosureExample
//
//  Created by Don Mag on 9/10/21.
//

import UIKit

class MyCVCell: UICollectionViewCell {
	@IBOutlet var theLabel: PaddedLabel!
}
class My_1_2Cell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
	@IBOutlet var cView: UICollectionView!
	
	var myData: [String] = []
	
	override func awakeFromNib() {
		super.awakeFromNib()
		cView.dataSource = self
		cView.delegate = self
	}
	
	func setData(_ viewSelected: Int) -> Void {
		// set data based on selected segment
		if viewSelected == 0 {
			myData = ["One", "Two", "Three", "Four", "Five"]
		} else {
			myData = ["Red", "Green", "Blue", "Cyan", "Magenta", "Yellow"]
		}
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return myData.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCVCell", for: indexPath) as! MyCVCell
		cell.theLabel.text = myData[indexPath.item]
		return cell
	}
	
}
class ProfileSegmentTableViewCell: UITableViewCell {
	@IBOutlet var profileSegmentControl: UISegmentedControl!
	
	var callback: ((Int)->())?
	
	@IBAction func segmentPressed(_ sender: Any) {
		guard let segControl = sender as? UISegmentedControl else { return }
		// tell the controller that the selected segment changed
		callback?(segControl.selectedSegmentIndex)
	}
}
class PlainCell: UITableViewCell {
	
}
class MyProfileTableViewController: UITableViewController {
	
	// track selected segment index
	var currentIndex: Int = 0
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// let's use 20 rows to confirm the first two rows
		//	segmented control
		//	collection view
		// get initialized properly when scrolling out-of and into view
		return 20
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			// first row - use cell with segemented control
			let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentTableViewCell", for: indexPath) as! ProfileSegmentTableViewCell
			
			// set the segemented control's selected index
			cell.profileSegmentControl.selectedSegmentIndex = self.currentIndex
			
			// set the callback closure
			cell.callback = { [weak self] idx in
				guard let self = self else {
					return
				}
				// update the segment index tracker
				self.currentIndex = idx
				// reload row containing collection view
				self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
			}
			
			return cell
		} else if indexPath.row == 1 {
			// second row - use cell with collection view
			let cell = tableView.dequeueReusableCell(withIdentifier: "1_2Cell", for: indexPath) as! My_1_2Cell
			
			// tell the cell which segment index is selected
			cell.setData(currentIndex)
			
			return cell
		}
		
		// all other rows - use simple Basic cell
		let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as! PlainCell
		cell.textLabel?.text = "Row \(indexPath.row)"
		return cell
	}
}

// simple UILabel subclass that provides for padding
@IBDesignable
class PaddedLabel: UILabel {
	
	@IBInspectable var topInset: CGFloat = 5.0
	@IBInspectable var bottomInset: CGFloat = 5.0
	@IBInspectable var leftInset: CGFloat = 5.0
	@IBInspectable var rightInset: CGFloat = 5.0
	
	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		super.drawText(in: rect.inset(by: insets))
	}
	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + leftInset + rightInset,
					  height: size.height + topInset + bottomInset)
	}
	override var bounds: CGRect {
		didSet {
			// ensures this works within other views if multi-line
			preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
		}
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = 6
		layer.masksToBounds = true
	}
}
