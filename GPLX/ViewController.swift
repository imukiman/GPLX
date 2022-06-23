//
//  ViewController.swift
//  GPLX
//
//  Created by MacOne-YJ4KBJ on 09/06/2022.
//

import UIKit
import RealmSwift
class ViewController: UIViewController {
    var items = [Items]()
    var passed = [Pass]()
    var cc = ManagerRealm.shareInstance.readData()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .bgColorBlue
        navigationController?.navigationBar.isHidden = true
        configCollectionView()
        readDataInApp()
        collectionView.reloadData()
        print(cc)
    }

    func configCollectionView(){
        self.view.addSubview(collectionView)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "LessionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellNLession")
        collectionView.register(UINib(nibName: "LessionPassCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellPLession")
        collectionView.register(UINib(nibName: "LessionFailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellFLession")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.view.bounds.width/2.1, height: self.view.bounds.width/3)
    }

    func readDataInApp(){
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return
        }
        let file = url.appendingPathComponent(AppDelegate.nameFolder).appendingPathComponent(AppDelegate.nameFileData)
        do{
            let data = try JSONDecoder().decode(Item.self, from: Data(contentsOf: file))
            for i in 0..<data.count{
                passed.append(.none)
                self.items.append(data[i])
            }
        }catch{
            print("Loi doc data")
        }
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cc[indexPath.item].passLession == "right"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPLession", for: indexPath) as! LessionPassCollectionViewCell
            cell.lblLessions.text = String("Đề số \(items[indexPath.item].lessions + 1)")
            cell.lblWrong.text = String(cc[indexPath.item].numberWrong)
            cell.lblRight.text = String(cc[indexPath.item].numberRight)
            return cell
        }
        if cc[indexPath.item].passLession == "wrong"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFLession", for: indexPath) as! LessionFailCollectionViewCell
            cell.lblLessions.text = String("Đề số \(items[indexPath.item].lessions + 1)")
            cell.lblWrong.text = String(cc[indexPath.item].numberWrong)
            cell.lblRight.text = String(cc[indexPath.item].numberRight)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNLession", for: indexPath) as! LessionsCollectionViewCell
        cell.lblLessions.text = String("Đề số \(items[indexPath.item].lessions + 1)")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vs = PageViewController()
        vs.questions = items[indexPath.item].questions
        vs.numberLession = indexPath.item
        vs.delegate1 = self
        vs.modalPresentationStyle = .fullScreen
        present(vs, animated: false)
    }
}

extension ViewController: updateLessionDelegate{
    func updateLession(lession: Int, pass: passLession) {
        ManagerRealm.shareInstance.updateObject(code: lession, numberRight: pass.numberRight, numberWrong: pass.numberWrong, passLession: pass.pass)
        self.collectionView.reloadData()
        
    }
}

