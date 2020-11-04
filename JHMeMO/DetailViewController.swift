//
//  DetailViewController.swift
//  JHMeMO
//
//  Created by 송정훈 on 2020/08/16.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var memo: Memo?
    @IBOutlet weak var memoTableView: UITableView!
    
    @IBAction func share(_ sender: Any) {
        guard let memo = memo?.content else {return}
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc,animated: true,completion: nil)
   
    }
    
    
    @IBAction func deleteMemo(_ sender: Any) {
        
        let alert = UIAlertController(title:"삭제 확인",message:"메모를 삭제할까요?",preferredStyle: .alert)
        //action 의 style 파라미터로 destructive 를 전달하면 메시지가 빨간 색으로 표시됨.
        let okAction = UIAlertAction(title:"삭제",style: .destructive){[weak self](action) in
            DataManager.shared.deleteMemo(self?.memo)
            //데이터를 삭제한다음
            self?.navigationController?.popViewController(animated: true)
            //viewcontroller를 이용하여 화면을 pop 해줌
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title:"취소",style:.cancel,handler:nil)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    let formatter: DateFormatter = {
           let f = DateFormatter()
           f.dateStyle = .long
           f.timeStyle = .short
           f.locale = Locale(identifier: "Ko_kr")
           return f
       }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //센더로 수정 버튼 전달
        if let vc = segue.destination.children.first as? ComposeViewController{
            vc.editTarget = memo
        }
    }
    var token: NSObjectProtocol?
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad() {
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.memoTableView.reloadData()
            })
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DetailViewController:UITableViewDataSource{
    //이전화면에서 전달한 메모가 저장되는 변수
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell",for: indexPath)
            cell.textLabel?.text = memo?.content
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell",for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            
                       return cell
        default:
            fatalError()
        
        }
    }
}
