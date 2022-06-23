//
//  PageViewController.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import UIKit
protocol updateLessionDelegate{
    func updateLession(lession: Int, pass: passLession)
}
struct passLession{
    let numberRight: Int
    let numberWrong: Int
    let pass: Pass
}

class PageViewController: UIPageViewController {
    var delegate1 : updateLessionDelegate?
    var questions = [Question]()
    var answers = [Answer]()
    var numberLession = 0
    let numberinrowColeectionView = 5
    var wrongOrRight = [Pass]()
    var itemWidth :CGFloat = 0
    var itemHeight :CGFloat = 50
    var timeAnswer = 18
    var timer = Timer()
    var numberRightAnswer = 0
    var numberWrongAnswer = 0
    var alert = UIAlertController()
    var passed : Pass = .none
    
    var viewtopMain = UIView()
    var viewContentInsideTop = UIView()
    var bt_Exit = UIButton()
    var lbl_timer = UILabel()
    var lbl_DidAnswer = UILabel()
    var number_DidAnswer = 0{
        didSet{
            self.lbl_DidAnswer.text = "\(number_DidAnswer) / \(questions.count)"
        }
    }
    
    var pages = [UIViewController]()
    var currenPage = 0{
        didSet{
            self.collectionView.reloadData()
            self.runScrollView()
        }
    }
    
    var viewBotMain = UIView()
    var viewBGBot = UIView()
    var viewbutton_nextandback = UIView()
    var bt_nextPage = UIButton()
    var bt_prevPage = UIButton()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        createArrayAnswer()
        configTop()
        configBot()
        configCollectionView()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timeAnswer -= 1
            self.lbl_timer.text = String(format: "%02d",self.timeAnswer/60) + " : " + String(format: "%02d", self.timeAnswer%60)
            if self.timeAnswer == 0{
                self.timer.invalidate()
                self.showAlert()
            }
        })
    }
    
    func configTop(){
        
        view.addSubview(viewtopMain)
        viewtopMain.translatesAutoresizingMaskIntoConstraints = false
        viewtopMain.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        viewtopMain.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        viewtopMain.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        viewtopMain.backgroundColor = .bgColorBlue
        
        viewtopMain.addSubview(viewContentInsideTop)
        viewContentInsideTop.translatesAutoresizingMaskIntoConstraints = false
        viewContentInsideTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        viewContentInsideTop.leadingAnchor.constraint(equalTo: viewtopMain.leadingAnchor, constant: 0).isActive = true
        viewContentInsideTop.trailingAnchor.constraint(equalTo: viewtopMain.trailingAnchor, constant: 0).isActive = true
        viewContentInsideTop.bottomAnchor.constraint(equalTo: viewtopMain.bottomAnchor, constant: 0).isActive = true
        viewContentInsideTop.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        viewContentInsideTop.addSubview(bt_Exit)
        bt_Exit.translatesAutoresizingMaskIntoConstraints = false
        bt_Exit.setTitle("Exit", for: .normal)
        bt_Exit.titleLabel?.textColor = .white
        bt_Exit.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bt_Exit.trailingAnchor.constraint(equalTo: viewContentInsideTop.trailingAnchor, constant: -10).isActive = true
        bt_Exit.centerYAnchor.constraint(equalTo: viewContentInsideTop.centerYAnchor, constant: 0).isActive = true
        bt_Exit.addTarget(self, action: #selector(exit_result), for: .touchUpInside)
        
        viewContentInsideTop.addSubview(lbl_timer)
        lbl_timer.translatesAutoresizingMaskIntoConstraints = false
        lbl_timer.textColor = .white
        lbl_timer.font = .boldSystemFont(ofSize: 18)
        lbl_timer.centerXAnchor.constraint(equalTo: viewContentInsideTop.centerXAnchor, constant: 0).isActive = true
        lbl_timer.centerYAnchor.constraint(equalTo: viewContentInsideTop.centerYAnchor, constant: 0).isActive = true
        lbl_timer.text = String(format: "%02d",self.timeAnswer/60) + " : " + String(format: "%02d", self.timeAnswer%60)
        
        viewContentInsideTop.addSubview(lbl_DidAnswer)
        lbl_DidAnswer.translatesAutoresizingMaskIntoConstraints = false
        lbl_DidAnswer.leadingAnchor.constraint(equalTo: viewContentInsideTop.leadingAnchor, constant: 10).isActive = true
        lbl_DidAnswer.centerYAnchor.constraint(equalTo: viewContentInsideTop.centerYAnchor, constant: 0).isActive = true
        lbl_DidAnswer.textColor = .white
        lbl_DidAnswer.font = .boldSystemFont(ofSize: 18)
        lbl_DidAnswer.text = "\(number_DidAnswer) / \(questions.count)"
    }
    
    @objc func exit_result(){
        AppDelegate.showAnswer = false
        dismiss(animated: true)
    }
    
    @objc func bt_click_next_question(){
        if currenPage < questions.count - 1{
            currenPage += 1
            setViewControllers([pages[currenPage]], direction: .forward, animated: true) { _ in
            }
        }
        
    }
    
    @objc func bt_click_prev_question(){
        if currenPage > 0{
            currenPage -= 1
            setViewControllers([pages[currenPage]], direction: .reverse, animated: true) { _ in
            }
        }
    }
    
    func updateLessions(){
        if passed != .none{
            let a = passLession(numberRight: numberRightAnswer, numberWrong: numberWrongAnswer, pass: passed)
            delegate1?.updateLession(lession: numberLession, pass: a)
        }
    }
    
    func configBot(){
        view.addSubview(viewBotMain)
        viewBotMain.addSubview(viewBGBot)
        view.sendSubviewToBack(viewBotMain)
        view.addSubview(viewbutton_nextandback)
        
        viewbutton_nextandback.addSubview(bt_nextPage)
        viewbutton_nextandback.addSubview(bt_prevPage)
        
        viewBotMain.translatesAutoresizingMaskIntoConstraints = false
        viewBotMain.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        viewBotMain.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        viewBotMain.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true
        
        viewbutton_nextandback.translatesAutoresizingMaskIntoConstraints = false
        
        viewbutton_nextandback.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        viewbutton_nextandback.leadingAnchor.constraint(equalTo: viewBotMain.leadingAnchor,constant: 0).isActive = true
        viewbutton_nextandback.trailingAnchor.constraint(equalTo: viewBotMain.trailingAnchor,constant: 0).isActive = true
        viewbutton_nextandback.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewbutton_nextandback.topAnchor.constraint(equalTo: viewBotMain.topAnchor, constant: 0).isActive = true
        
        viewBGBot.translatesAutoresizingMaskIntoConstraints = false
        viewBGBot.bottomAnchor.constraint(equalTo: viewBotMain.bottomAnchor, constant: 0).isActive = true
        viewBGBot.leadingAnchor.constraint(equalTo: viewBotMain.leadingAnchor,constant: 0).isActive = true
        viewBGBot.trailingAnchor.constraint(equalTo: viewBotMain.trailingAnchor,constant: 0).isActive = true
        viewBGBot.topAnchor.constraint(equalTo: viewBotMain.topAnchor, constant: 0).isActive = true
        viewBGBot.backgroundColor = .bgColorBlue
        
        bt_nextPage.translatesAutoresizingMaskIntoConstraints = false
        bt_nextPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        bt_nextPage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt_nextPage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt_nextPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        bt_nextPage.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        bt_nextPage.addTarget(self, action: #selector(bt_click_next_question), for: .touchUpInside)
        bt_nextPage.tintColor = .white
        
        bt_prevPage.translatesAutoresizingMaskIntoConstraints = false
        bt_prevPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        bt_prevPage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt_prevPage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt_prevPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        bt_prevPage.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        bt_prevPage.tintColor = .white
        bt_prevPage.addTarget(self, action: #selector(bt_click_prev_question), for: .touchUpInside)
        
    }
    
    func createArrayAnswer(){
        dataSource = self
        delegate = self
        for i in 0..<questions.count{
            wrongOrRight.append(Pass.none)
            answers.append(Answer(numberQ: i, passQ: .none, yourAnswer: -1, numberRight: questions[i].numberCorrectQ))
            let vc = OnboardViewController()
            vc.delegate = self
            vc.numberCurrentQuestion = i
            vc.infoCurrentQuestion = questions[i]
            pages.append(vc)
        }
        setViewControllers([pages[currenPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func configCollectionView(){
        view.addSubview(collectionView)
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: "NormalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCPage")
        collectionView.register(UINib(nibName: "RightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCRPage")
        collectionView.register(UINib(nibName: "WrongCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCWPage")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: viewtopMain.bottomAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        itemWidth = self.view.bounds.width/CGFloat(numberinrowColeectionView)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func showAlert(){
        numberWrongAnswer = questions.count - numberRightAnswer
        self.timer.invalidate()
        if numberWrongAnswer >= 3{
            alert = UIAlertController(title: "Bạn đã trượt \(numberRightAnswer)/\(questions.count)", message: "Ấn Cancel để xem lại đáp án, ấn Exit để thoát", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Exit", style: UIAlertAction.Style.default, handler: { _ in
                self.dismiss(animated: true)
                self.updateLessions()
                AppDelegate.showAnswer = false
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                AppDelegate.showAnswer = true
                for i in 0..<self.wrongOrRight.count{
                    if self.wrongOrRight[i] == .none{
                        self.wrongOrRight[i] = .wrong
                    }
                }
                self.collectionView.reloadData()
                self.currenPage = 0
                self.setViewControllers([self.pages[self.currenPage+1]], direction: .reverse, animated: false)
                self.setViewControllers([self.pages[self.currenPage]], direction: .reverse, animated: false)
            }))
            self.passed = .wrong
        }
        else{
            passed = .right
            alert = UIAlertController(title: "Bạn đã đỗ \(numberRightAnswer)/\(questions.count)", message: "Xin Chúc Mừng Bạn. Ấn Cancel để xem lại đáp án, ấn Exit để thoát", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Exit", style: UIAlertAction.Style.default, handler: { _ in
                self.dismiss(animated: true)
                self.updateLessions()
                AppDelegate.showAnswer = false
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                AppDelegate.showAnswer = true
                for i in 0..<self.wrongOrRight.count{
                    if self.wrongOrRight[i] == .none{
                        self.wrongOrRight[i] = .wrong
                    }
                }
                self.collectionView.reloadData()
                self.currenPage = 0
                self.setViewControllers([self.pages[self.currenPage+1]], direction: .reverse, animated: false)
                self.setViewControllers([self.pages[self.currenPage]], direction: .reverse, animated: false)
            }))
            self.passed = .right
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func runScrollView(){
        if currenPage <= 2{
            UIView.animate(withDuration: 0.3) {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
        if currenPage > 2 && currenPage <= wrongOrRight.count - 3{
            UIView.animate(withDuration: 0.3) {
                self.collectionView.contentOffset = CGPoint(x: CGFloat(self.currenPage - 2)*self.itemWidth, y: 0)
            }
        }
        if currenPage > wrongOrRight.count - 3{
            UIView.animate(withDuration: 0.3) {
                self.collectionView.contentOffset = CGPoint(x: CGFloat(self.wrongOrRight.count - self.numberinrowColeectionView)*self.itemWidth, y: 0)
            }
        }
    }
}

extension PageViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wrongOrRight.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if wrongOrRight[indexPath.item] == .right{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCRPage", for: indexPath)as! RightCollectionViewCell
            cell.numberquetion = indexPath.item + 1
            if currenPage == indexPath.item{
                cell.border_select.backgroundColor = .bgColorBlue
                cell.lbl_number_collectionviewcell.textColor = .bgColorBlue
            }
            else{
                cell.border_select.backgroundColor = .clear
                cell.lbl_number_collectionviewcell.textColor = .darkGray
            }
            return cell
        }
        if wrongOrRight[indexPath.item] == .wrong{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCWPage", for: indexPath)as! WrongCollectionViewCell
            cell.numberquetion = indexPath.item + 1
            if currenPage == indexPath.item{
                cell.border_select.backgroundColor = .bgColorBlue
                cell.lbl_number_collectionviewcell.textColor = .bgColorBlue
            }
            else{
                cell.border_select.backgroundColor = .clear
                cell.lbl_number_collectionviewcell.textColor = .darkGray
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCPage", for: indexPath)as! NormalCollectionViewCell
        cell.numberquetion = indexPath.item + 1
        if currenPage == indexPath.item{
            cell.border_select.backgroundColor = .bgColorBlue
            cell.lbl_number_collectionviewcell.textColor = .bgColorBlue
        }
        else{
            cell.border_select.backgroundColor = .clear
            cell.lbl_number_collectionviewcell.textColor = .darkGray
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currenPage < indexPath.item{
            currenPage = indexPath.item
            setViewControllers([pages[currenPage]], direction: .forward, animated: true, completion: nil)
        }
        if currenPage > indexPath.item{
            currenPage = indexPath.item
            setViewControllers([pages[currenPage]], direction: .reverse, animated: true, completion: nil)
        }
    }

}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            //currenPage = currentIndex
            return nil
            // wrap last return pages.last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        }
        else{
            //currenPage = currentIndex
            return nil
            // wrap first pages.first
        }
    }
}

// MARK: - Delegates

extension PageViewController: UIPageViewControllerDelegate {
    
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        if currenPage != currentIndex{
            currenPage = currentIndex
        }
        runScrollView()
    }
    
    private func animateControlsIfNeeded() {

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

extension PageViewController: OnboardDelegate{
    func updateAnswer(number: Int, pass: Pass) {
        self.wrongOrRight[number] = pass
        self.collectionView.reloadData()
        self.number_DidAnswer += 1
        if pass == .right{
            self.numberRightAnswer += 1
            self.numberWrongAnswer = self.questions.count - self.numberRightAnswer
        }
        if self.number_DidAnswer == self.questions.count{
            self.showAlert()
        }
    }
}
