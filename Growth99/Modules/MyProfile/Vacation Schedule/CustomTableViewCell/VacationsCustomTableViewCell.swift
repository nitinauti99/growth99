//
//  VacationsCustomTableViewCell.swift
//  Growth99
//
//  Created by admin on 03/12/22.
//

import UIKit

protocol CellSubclassDelegate: AnyObject {
    func buttontimeFromTapped(cell: VacationsCustomTableViewCell)
    func buttontimeToTapped(cell: VacationsCustomTableViewCell)

}

class VacationsCustomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var addTimeButton: UIButton!
    @IBOutlet weak var removeTimeButton: UIButton!
    @IBOutlet weak var timeFromTextField: CustomTextField!
    @IBOutlet weak var timeToTextField: CustomTextField!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var borderView: UIView!

    // MARK: - Button closures
    var buttonRemoveTapCallback: () -> ()  = { }
    var buttonAddTimeTapCallback: () -> ()  = { }
    var userScheduleTimings: [UserScheduleTimings]?
    weak var delegate: CellSubclassDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(timeFromDoneButtonPressed), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(timeToDoneButtonPressed), mode: .time)
      
        addLeftBorder(with: UIColor.init(hexString: "#009EDE"), andWidth: 1)
        addRightBorder(with: UIColor.init(hexString: "#009EDE"), andWidth: 1)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    // MARK: - Time from picker done method
    @objc func timeFromDoneButtonPressed() {
        self.delegate?.buttontimeFromTapped(cell: self)
    }
    
    // MARK: - Time to picker done method
    @objc func timeToDoneButtonPressed() {
        self.delegate?.buttontimeToTapped(cell: self)
    }
    
    // MARK: - Update textfield methos
    func updateTimeFromTextField(with content: String) {
        timeFromTextField.text = content
    }
    
    func updateTimeToTextField(with content: String) {
        timeToTextField.text = content
    }
    
    // MARK: - Add and remove time methods
    @IBAction func addTimeButtonAction(sFender: UIButton) {
        buttonAddTimeTapCallback()
        borderView.isHidden = true
    }
    
    @IBAction func removeTimeButtonAction(sender: UIButton) {
        buttonRemoveTapCallback()
        borderView.isHidden = false
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        subView.addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        subView.addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        subView.addSubview(border)
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        subView.addSubview(border)
    }
}
