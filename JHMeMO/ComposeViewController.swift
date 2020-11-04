//
//  ComposeViewController.swift
//  JHMeMO
//
//  Created by 송정훈 on 2020/08/13.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    var editTarget:Memo?
    var originalMemoContent:String? //편집 이전의 메모저장
    
     
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }// ->화면을 닫을 때 에니메이션 전환 파라미터, 닫을떄 코드
    
    @IBOutlet weak var memoTextView: UITextView!
    //outlet
    
    //save 버튼 이벤트
    @IBAction func save(_ sender: Any) {
        guard let memo =  memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요")
            return
        }
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        if let target = editTarget{
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name:ComposeViewController.memoDidChange,object: nil)
        }else{
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name:ComposeViewController.newMemoDidInsert,object: nil)//notification은 브로드캐스트 모든객체로 전달
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    var willShowToken:NSObjectProtocol?
    var willHideToken:NSObjectProtocol?
    deinit{
        if let token = willShowToken{
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken{
            NotificationCenter.default.removeObserver(token)
        }
    }
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo = editTarget{
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        }else{
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        memoTextView.delegate = self
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let strongSelf = self else {return}
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                let height = frame.cgRectValue.height   //키보드 높이 저장
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let strongSelf = self else {return}
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
        })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoTextView.becomeFirstResponder() //진입시 키보드를 띄어줌
        navigationController?.presentationController?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        memoTextView.resignFirstResponder() //나갈때 키보드를 사라지게 함
        navigationController?.presentationController?.delegate = nil
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
extension ComposeViewController:UITextViewDelegate{     //텍스트뷰에서 텍스트를 편집할때 마다 반복적으로 호출되는 메소드
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text{
            if #available(iOS 13.0, *) {    //원본과 비교하여 원본과 다르면 TRUE를 리턴함
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
//메모 내용이 변경된 상태에서 풀다운을 하면 내용이 사라지지 않고 아래의 메소드가 호출됨
extension ComposeViewController:UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title:"알림",message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        //파라 미터로 전달된 클로저가 실행됨 확인 버튼을 누르면,
        let okAction = UIAlertAction(title:"확인",style:.default) { [weak self](action) in
            self?.save(action)
        }
        alert.addAction(okAction)
        
        let cancelAction  = UIAlertAction(title:"취소",style: .default){[weak self](action) in
            self?.close(action)
        }
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil )
    }
}
extension ComposeViewController{//notifications ex.)->라디오 방송 주파수 구분 처럼 이름으로 구분함
    static let newMemoDidInsert = Notification.Name(rawValue:"newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue:"memoDidChange")
}
