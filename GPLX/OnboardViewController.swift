//
//  OnboardViewController.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import UIKit

protocol OnboardDelegate{
    func updateAnswer(number: Int, pass: Pass)
}

class OnboardViewController: UIViewController {
    var delegate : OnboardDelegate?
    var numberCurrentQuestion = -1
    var infoCurrentQuestion : Question?
    var ContentView = UIView()
    
    var scrollView = UIScrollView()
    var contentInside_scrollview = UIView()
    var lbl_number_title_Question = UILabel()
    var lbl_Question = UILabel()
    var bt_confirm_answer = UIButton()
    var tableView = UITableView()
    var image_Question = UIImageView()
    
    var height_tableview = NSLayoutConstraint()
    
    var number_yourAnswer = -1
    var number_rightAnswer = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTop()
        configBot()
        configTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.selectRow(at: nil, animated: true, scrollPosition: UITableView.ScrollPosition.top)
        bt_confirm_answer.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppDelegate.showAnswer == true{
            number_rightAnswer = infoCurrentQuestion!.numberCorrectQ
            tableView.allowsSelection = false
            tableView.reloadData()
        }
    }
    private func configTop(){
        view.addSubview(scrollView)
        scrollView.addSubview(ContentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        
        ContentView.translatesAutoresizingMaskIntoConstraints = false
        ContentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        ContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        ContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        ContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        ContentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        
        ContentView.addSubview(lbl_number_title_Question)
        lbl_number_title_Question.translatesAutoresizingMaskIntoConstraints = false
        lbl_number_title_Question.topAnchor.constraint(equalTo: ContentView.topAnchor, constant: 5).isActive = true
        lbl_number_title_Question.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 10).isActive = true
        lbl_number_title_Question.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -10).isActive = true
        lbl_number_title_Question.text = "Cau hoi \(numberCurrentQuestion + 1)"
        
        ContentView.addSubview(lbl_Question)
        
        lbl_Question.translatesAutoresizingMaskIntoConstraints = false
        lbl_Question.topAnchor.constraint(equalTo: lbl_number_title_Question.bottomAnchor, constant: 10).isActive = true
        lbl_Question.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        lbl_Question.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        lbl_Question.text = infoCurrentQuestion?.titleQ
        lbl_Question.numberOfLines = 0
        
        
        ContentView.addSubview(image_Question)
        image_Question.translatesAutoresizingMaskIntoConstraints = false
        configImageQuestion()
    }
    
    func configImageQuestion(){
        image_Question.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 10).isActive = true
        image_Question.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -10).isActive = true
        
        guard let question = infoCurrentQuestion?.imageQ else{
            image_Question.heightAnchor.constraint(equalToConstant: 0).isActive = true
            image_Question.topAnchor.constraint(equalTo: lbl_Question.bottomAnchor, constant: 0).isActive = true
            return
        }
        image_Question.topAnchor.constraint(equalTo: lbl_Question.bottomAnchor, constant: 10).isActive = true
        image_Question.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image_Question.image = UIImage(named: question)
        image_Question.contentMode = .scaleAspectFit
    }
    
    func configBot(){
        view.addSubview(bt_confirm_answer)
        
        bt_confirm_answer.isHidden = true
        bt_confirm_answer.translatesAutoresizingMaskIntoConstraints = false
        bt_confirm_answer.widthAnchor.constraint(equalToConstant: 50).isActive = true
        bt_confirm_answer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bt_confirm_answer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        bt_confirm_answer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        bt_confirm_answer.backgroundColor = .darkGray
        bt_confirm_answer.layer.cornerRadius = 25
        bt_confirm_answer.setImage(UIImage(systemName: "checkmark"), for: .normal)
        bt_confirm_answer.tintColor = .white
        bt_confirm_answer.addTarget(self, action: #selector(click_bt_confirm_answer), for: .touchUpInside)
    }
    
    @objc func click_bt_confirm_answer(){
        guard let question = infoCurrentQuestion else{
            return
        }
        number_rightAnswer = question.numberCorrectQ
        if number_yourAnswer == number_rightAnswer{
            delegate?.updateAnswer(number: numberCurrentQuestion, pass: .right)
        }
        else{
            delegate?.updateAnswer(number: numberCurrentQuestion, pass: .wrong)
        }
        bt_confirm_answer.isHidden = true
        tableView.reloadData()
        tableView.allowsSelection = false
    }
    
    func configTableView(){
        ContentView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
    
        
        tableView.topAnchor.constraint(equalTo: image_Question.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: ContentView.bottomAnchor, constant: -10).isActive = true
        tableView.backgroundColor = .red
        height_tableview = tableView.heightAnchor.constraint(equalToConstant: 500)
        height_tableview.isActive = true
        tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTNormal")
        tableView.register(UINib(nibName: "RightTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTRight")
        tableView.register(UINib(nibName: "WrongTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTWrong")
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            self.height_tableview.isActive = false
            self.tableView.heightAnchor.constraint(equalToConstant: self.tableView.contentSize.height).isActive = true
        }
    }
}
extension OnboardViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (infoCurrentQuestion?.arrayAnswersQ.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let question =  infoCurrentQuestion?.arrayAnswersQ else{
            return UITableViewCell()
        }
        if indexPath.row == number_rightAnswer{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTRight")as! RightTableViewCell
            cell.lbl_Answer.text = question[indexPath.row]
            return cell
        }
        if indexPath.row == number_yourAnswer{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTWrong")as! WrongTableViewCell
            cell.lbl_Answer.text = question[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTNormal")as! NormalTableViewCell
        cell.lbl_Answer.text = question[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        number_yourAnswer = indexPath.row
        bt_confirm_answer.isHidden = false
    }
}
