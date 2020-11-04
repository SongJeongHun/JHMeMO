/*
 1.테이블 뷰 배치
 2.프로토타입 셀 디자인 셀 아이덴티파이어 지정
 3.데이터 소스, 델리게이트 연결
 4.데이터 소스 구현
 5.델리게이트 구현
 */
import UIKit

class MemoListTableViewController: UITableViewController {  //UITableViewController클래스를 상속 받음
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    //->ios 13 이후에는 sheet 가 아니기 때문에 모달
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.fetchMemo()
        tableView.reloadData()
    }
    
    var token:NSObjectProtocol?
    
    deinit{
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    //source 와 destination  새그웨이를 실행하는 화면과 새롭게 표시되는 화면
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        if let cell = sender as? UITableViewCell,let indexPath = tableView.indexPath(for: cell){
            if let vc = segue.destination as? DetailViewController{
                vc.memo =  DataManager.shared.memoList[indexPath.row]
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() //=->초기화 코드
        
        //notification은 사용후 닫아주어야 함
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak  self] (noti) in
            self?.tableView.reloadData()
        }
        //-> UI 업데이틑 메인 쓰레드 에서 해야함  4번째 파라미터로 전달한 클로저가 3번째 파라미터로 전달한 쓰레드 에서 실행됨
        
        
        
        
        
        

        
    }

    // MARK: - Table view data source
    
    
    
    
    //module 에 있는 더미리스트의 셀의 게수 만큼 표기
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.memoList.count //셀의 개수를 리턴 받아서 셀
    }

    //가장 중요한 메소드(테이블 뷰를 어떤 디자인으로 출력 해야 하는 지를 알려주는 메소드)  셀을 표시할때 마다 반복적ㅈ으로 표출
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //-> deque 메소드를 통해 "cell" 이름의 셀을 불러와 let cell 상수에 저장, 불러올때의 셀은 비어있음
        let target =  DataManager.shared.memoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(for:target.insertDate)
        

        return cell
            //세을 터치했을떄 표시 ㅎ하는것-> 델리게이트를 연결하고 메소드를 구현 델리게이트는 필수는 아님,
    }
    

    
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
        
    }
    

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let target = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.deleteMemo(target)   //->DB 에서 삭제
            DataManager.shared.memoList.remove(at: indexPath.row)
           
            //데이터의 있는 열의 개수와 테이블 뷰에 있는 셀의 개수가 일치 하지 않으면 크래쉬 발생
            tableView.deleteRows(at: [indexPath], with: .fade)  //-> 테이블 뷰에서 삭제
            
        } else if editingStyle == .insert {
           
        }    
    }
  

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
