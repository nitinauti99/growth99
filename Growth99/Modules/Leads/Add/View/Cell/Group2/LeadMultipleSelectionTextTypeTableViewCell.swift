//
//  MultipleSelectionTextTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class LeadMultipleSelectionTextTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var inputeTypeTextField: CustomTextField!
    @IBOutlet var questionnareTableView: UITableView!
    @IBOutlet weak var questionnareTableViewHight: NSLayoutConstraint!
    @IBOutlet weak var subView: UIView!
    
    var patientQuestionChoices = [PatientQuestionChoices]()
    var preSelected:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionnareTableView.register(UINib(nibName: "LeadMultipleSelectionQuestionChoiceTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadMultipleSelectionQuestionChoiceTableViewCell")
        self.questionnareTableViewHight.constant = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.questionnareTableViewHight.constant = CGFloat(self.patientQuestionChoices.count * 40)
    }
    
    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
        self.patientQuestionChoices = questionarieVM?.patientQuestionChoices ?? []
        self.preSelected = questionarieVM?.preSelectCheckbox ?? false
    }
    
    func getTableView()-> UITableView {
        return self.questionnareTableView
    }
    
}

extension LeadMultipleSelectionTextTypeTableViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patientQuestionChoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = questionnareTableView.dequeueReusableCell(withIdentifier: "LeadMultipleSelectionQuestionChoiceTableViewCell") as? LeadMultipleSelectionQuestionChoiceTableViewCell else { return LeadMultipleSelectionQuestionChoiceTableViewCell() }

        let patientQuestionChoices = self.patientQuestionChoices[indexPath.row]
        cell.configureCell(patientQuestionChoices: patientQuestionChoices, index: indexPath, preSelected: self.preSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
