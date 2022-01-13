//
//  PlayViewController.swift
//  Lesson 12
//
//  Created by Alex Paramonov on 19.07.21.
//

import UIKit


enum Chakers: Int {
     case white = 0
     case pink = 1
     
}

class PlayViewController: UIViewController{

	@IBOutlet weak var backgroundImageStyle: UIImageView!
	@IBOutlet weak var labelTimer: UILabel!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelGameTime: UILabel!
	@IBOutlet weak var buttonBackMainMenu: UIButton!
     
	var board: UIView!
	var timer : Timer?
	var countTickSec: Int = 0
	var countTickMin: Int = 0
	var cheker: UIImageView!
	var currentChecker: Chakers  = .white
	var cellAndChekers: [Checker] = []
	let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	let userDefault = UserDefaults.standard
	let fileManager = FileManager.default
	let dateDormatter = DateFormatter()
	var styleCheker = StyleCheker(styleCheker: nil, position: false)
	var cellsForMove: [UIView] = []
	var names: [SaveName] = []
	var nameOnePlayers: String?
    var nameTwoPlayers: String?
	var randomName: [String] = []
    var playerWhite = ""
	var playerPink = ""
	var dataGame = ""
	var gameTime = 0
     
	var players: [Players_Model] = []
	var canFight: Bool = false
	
	var mass: [(checker: Int, cell: Int, checkerBeaten: Int)] = []


    override func viewDidLoad() {
        super.viewDidLoad()
     	localized()
     	getAndSetNames ()
     	getData()
     	setTimer ()
     	getStyleCheker ()
     	createBoard()
     	Fight()
     	self.cellAndChekers.removeAll()
     	setBackgroundImage()
     	
      	
    }
     
     
     override func viewWillAppear(_ animated: Bool) {
     	super.viewWillAppear(animated)
     	self.navigationController?.navigationBar.isHidden = true
     }
     
   
     
     
     func setTimer () {
          timer = Timer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
          RunLoop.main.add(timer!, forMode: .common)
          labelTimer.attributedText = NSAttributedString(string: "\(countTickMin) min : \(countTickSec) sec",
                                                      attributes: [
                                                       .font : UIFont(name: "GloriaHallelujah", size: 20) ?? UIFont.systemFont(ofSize: 20),
                                                      ])
    
          view.addSubview(labelTimer)
     }
     
     func getAndSetNames () {
     
          let fileURL = documentDirectory.appendingPathComponent(Keys.namePlayers.rawValue)
          
          guard let data = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) else { return}
          
          guard let newObject = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SaveName] else {return}
          self.names = newObject
          
          names.forEach { value in
               randomName.append(value.nameOne)
               randomName.append(value.nameTwo)
          }
          
          if !fileManager.fileExists(atPath: documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue).path) {
          playerWhite = randomName.randomElement() ?? ""
          playerPink = ( playerWhite == randomName[0]) ? randomName[1]: randomName[0]
               
               if SettingManager.shared.currentLanguage == "en" {
                    labelName.text = (currentChecker == .white) ? "\(playerWhite)'s turn"  : "\(playerPink)'s turn"
               } else {
                    labelName.text = (currentChecker == .white) ? "\(playerWhite) ходит"  : "\(playerPink) ходит"
               }
               
          guard let name = nameOnePlayers, name != "" else {return}
          labelName.text = name
          }
     }
     
     func createBoard() {
          
     	let size = view.bounds.size.width - 32
          
     	board = UIView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
     	board.backgroundColor = .white
     	board.center = view.center
     	view.addSubview(board)
          
     	let sizeColumn = size / 8
          
     	var counterCell = 0
     	var counterCheker = 0
     	for row in 0..<8  {
     		for column in 0..<8 {
          		let square = UIView(frame: CGRect(x: sizeColumn * CGFloat(column),
                                                  y: sizeColumn * CGFloat(row),
                                                  width: sizeColumn,
                                                  height: sizeColumn))
               	square.backgroundColor =  ((column + row) % 2) == 0 ? .white : .black
               	square.tag = counterCell
               
               	board.addSubview(square)
               	counterCell += 1
               
               	cheker = UIImageView(frame: CGRect(x: 5, y: 5, width: sizeColumn - 10 , height: sizeColumn - 10))
               	cheker.isUserInteractionEnabled = true
               
               	let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesture(_ :)))
               	longGesture.minimumPressDuration = 0.1
               	longGesture.delegate = self
               	cheker.addGestureRecognizer(longGesture)
               

               	let panCesture = UIPanGestureRecognizer(target: self, action: #selector(punGesture(_: )))
               	panCesture.delegate = self
               	cheker.addGestureRecognizer(panCesture)

               
               
          		guard !cellAndChekers.isEmpty else {
                    
                 
               		guard row < 3 || row > 4 , square.backgroundColor == .black   else {continue}
                    
                    if styleCheker.position == true {
               			cheker.image = row < 3 ? UIImage(named: "1") : UIImage(named: styleCheker.styleCheker ?? "2")
                    	cheker.tag = counterCheker
               			counterCheker += 1
                         
                    } else {
               			cheker.image = row < 3 ? UIImage(named: "1") : UIImage(named: "2")
                    	cheker.tag = counterCheker
                    	counterCheker += 1
                    }
                   
                    square.addSubview(cheker)
                    continue
               }
               
               
               if let chekers = cellAndChekers.first(where: { $0.tagCell == square.tag })   {
                    cheker.image = UIImage(named: chekers.tagCheker < 12 ?  "1" : styleCheker.styleCheker ?? "2")
                    cheker.tag =  chekers.tagCheker
                    square.addSubview(cheker)
                    if chekers.queen == true {
                         let queen = UIImageView(frame: CGRect(x: 12, y: 12, width: 15, height: 15))
                    	queen.image = UIImage(named: "queenWhite")

                         cheker.addSubview(queen)
                    }
               }
          	}
     	}
}
     
     func getStyleCheker () {
     	let fileURL = documentDirectory.appendingPathComponent(Keys.styleChekers.rawValue)

     	guard let data = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) else {return}
          
     	guard let newObject = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [StyleCheker] else { return }
          
     	newObject.forEach { style in
     		if style.position == true {
          		self.styleCheker = style
          	}
     	}
     }
     
     
   	func  getData() {
          if fileManager.fileExists(atPath: documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue).path) {
               getTime()
               getSaveCheker()
               getName()
          }
     }
     
     func saveName() {
          userDefault.set(playerWhite, forKey: Keys.playerWhite.rawValue)
          userDefault.set(playerPink, forKey: Keys.playerPink.rawValue)
     }
     
     func getName() {
          playerWhite = userDefault.object(forKey: Keys.playerWhite.rawValue) as?  String ?? "PlayerOne"
          playerPink = userDefault.object(forKey: Keys.playerPink.rawValue) as? String ?? "PlayerTwo"
          
          if SettingManager.shared.currentLanguage == "en" {
               labelName.text = (currentChecker == .white) ? "\(playerWhite)'s turn"  : "\(playerPink)'s turn"
          } else {
               labelName.text = (currentChecker == .white) ? "\(playerWhite) ходит"  : "\(playerPink) ходит"
          }
     }
     
     func removeName () {
          userDefault.removeObject(forKey: Keys.playerWhite.rawValue)
          userDefault.removeObject(forKey: Keys.playerPink.rawValue)
     }
     
     func saveChekers (){
          cellAndChekers = []
          board.subviews.forEach { cell in
               if !cell.subviews.isEmpty {
                    cell.subviews.forEach { cheker in
                         if !cheker.subviews.isEmpty {
                         let value = Checker(tagCell: cell.tag, tagCheker: cheker.tag, queen: true)
                         cellAndChekers.append(value)
                         } else {
                              let value = Checker(tagCell: cell.tag, tagCheker: cheker.tag, queen: false)
                              cellAndChekers.append(value)
                         }
                    }
               }
          }
          
          let data = try? NSKeyedArchiver.archivedData(withRootObject: cellAndChekers, requiringSecureCoding: true)
          let fileURL = documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue)
          try? data?.write(to: fileURL)
         
     }
     
 
     
     func saveTimeAndCurrentCheker() {
      
          userDefault.setValue(countTickSec, forKey: Keys.countTickSec.rawValue)
          userDefault.setValue(countTickMin, forKey: Keys.countTickMin.rawValue)
          userDefault.setValue(currentChecker.rawValue, forKey: Keys.currentCheker.rawValue)
     }
     
     func getSaveCheker() {
          
          let fileURL = documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue)
     
          guard let data  = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) else {return}
          
          let newObject = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Checker]
          
          cellAndChekers = newObject ?? []
     }
     
     func getTime() {
          
          let min = userDefault.integer(forKey: Keys.countTickMin.rawValue)
          self.countTickMin = min
          let sec = userDefault.integer(forKey: Keys.countTickSec.rawValue)
          self.countTickSec = sec
          
          let dataCurrentCheker = userDefault.integer(forKey: Keys.currentCheker.rawValue)
          self.currentChecker = dataCurrentCheker == 0 ? .white : .pink
     }
     
     private func setBackgroundImage () {
          let fileUrl = documentDirectory.appendingPathComponent(Keys.styleBackground.rawValue)
          
          guard let data = FileManager.default.contents(atPath: fileUrl.absoluteString.replacingOccurrences(of: "file://", with: "")) else { return }
          let image = UIImage(data: data)
          backgroundImageStyle.image = image
     }
     
     func move (for checker:UIView) {
             let cell = checker.superview
          guard checker.subviews.isEmpty else {searchLadyMove(for: checker)
               return }
             board.subviews.forEach { cellForMove in
               guard cellForMove.subviews.isEmpty, cellForMove.backgroundColor == .black , let firstCell = cell else { return }
               
               		let valueOne = currentChecker == .white ? 7 : -7
               		let valueTwo = currentChecker == .white ? 9 : -9
               	
               		if cellForMove.tag == firstCell.tag + valueOne || cellForMove.tag == firstCell.tag + valueTwo {
                    	cellForMove.layer.borderWidth = 3
                    	cellForMove.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                    	cellsForMove.append(cellForMove)
                    }
                
             }
     }
     
	func Fight() {
     	saveChekers()
          
     	let arrayCheker = cellAndChekers
             
     	if currentChecker == .white {

         searchFightWhiteChecker(arrayCheker)

        } else {
             searchFightBlackChecker(arrayCheker)
          }
     }
     
     func checkMoveCheckers (arrayCheckers: [Checker]) -> String {
          
     	var won: String = ""
     	var arrayWhiteCheker: [Checker] = []
     	var arrayPinkCheker:[Checker] = []
                  
     	arrayCheckers.forEach { checker in
                    
     		board.subviews.forEach { cell in
          		if checker.tagCheker < 12, currentChecker == .white, cell.subviews.isEmpty, cell.backgroundColor == .black, (cell.tag == checker.tagCell + 7 ||  cell.tag == checker.tagCell + 9) {
                    arrayWhiteCheker.append(checker)
                              
                          }
                 if checker.tagCheker >= 12, currentChecker == .pink, cell.subviews.isEmpty, cell.backgroundColor == .black, (cell.tag == checker.tagCell - 7 ||  cell.tag == checker.tagCell - 9) {
                      arrayPinkCheker.append(checker)
                          }
                      }
                  }
                  
                  if arrayWhiteCheker.isEmpty, currentChecker == .white {
                      won = playerPink
                      let playerss =  Players_Model(
                            name_player1: playerPink,
                            name_player2: playerWhite,
                            won: playerPink,
                            color_cheker_player2: "White",
                            color_cheker_player1: "Pink")

                                   players.append(playerss)
                       let date = Date()
                       dateDormatter.dateFormat = "dd.MM.yy"
                       dataGame = dateDormatter.string(from: date)
                       
                       gameTime = (countTickMin != 0) ? countTickMin * 60 + countTickSec : countTickSec
                       
                       
                       let dateToday = dateDormatter.date(from: dataGame)
                       let game = Game_Model(game_time: Int64(gameTime), game_date: dateToday ?? Date() , players: players)
                       CoreDataManeger.shared.saveGame(by: game)
                  }

                  if arrayPinkCheker.isEmpty, currentChecker == .pink {
                      won = playerWhite
                       let playerss =  Players_Model(
                            name_player1: playerPink,
                            name_player2: playerWhite,
                            won: playerWhite,
                            color_cheker_player2: "White",
                            color_cheker_player1: "Pink")

                                   players.append(playerss)
                       let date = Date()
                       dateDormatter.dateFormat = "dd.MM.yy"
                       dataGame = dateDormatter.string(from: date)
                       
                       gameTime = (countTickMin != 0) ? countTickMin * 60 + countTickSec : countTickSec
                       
                       
                       let dateToday = dateDormatter.date(from: dataGame)
                       let game = Game_Model(game_time: Int64(gameTime), game_date: dateToday ?? Date() , players: players)
                       CoreDataManeger.shared.saveGame(by: game)

                     
                  }
          return won
     }
     
     func searchFightWhiteQueen (queenCheker: Checker, arrayOfChecker: [Checker]) {
         
             var arrayQueen: [(lady: Int, checkerForFight: Int, cell: Int)] = []
         
             var a = queenCheker.tagCell - 9
             var b = queenCheker.tagCell - 7
             var c = queenCheker.tagCell + 7
             var d = queenCheker.tagCell + 9
             var one: Bool = true
             var two: Bool = true
             var three: Bool = true
             var four: Bool = true
             
             while a > 0 || b > 0 || c < 63 || d < 63 {
                 
                 arrayOfChecker.forEach { checkerForFight in
                     if checkerForFight.tagCheker >= 12  && (checkerForFight.tagCell == a || checkerForFight.tagCell == b || checkerForFight.tagCell == c || checkerForFight.tagCell == d) {
                         var step: Int = 0
                         if (queenCheker.tagCell - checkerForFight.tagCell) < 0, two == true, (queenCheker.tagCell - checkerForFight.tagCell) % 7 == 0 {
                             step = -7
                              two = false
                         }
                         if (queenCheker.tagCell - checkerForFight.tagCell) > 0, three == true, (queenCheker.tagCell - checkerForFight.tagCell) % 7 == 0 {
                             step = 7
                              three = false
                         }
                         if (queenCheker.tagCell - checkerForFight.tagCell) < 0, one == true, (queenCheker.tagCell - checkerForFight.tagCell) % 9 == 0 {
                             step = -9
                              one = false
                         }
                         if (queenCheker.tagCell - checkerForFight.tagCell) > 0, four == true, (queenCheker.tagCell - checkerForFight.tagCell) % 9 == 0 {
                             step = 9
                              four = false
                         }
                         
                         board.subviews.forEach { cell in
                             
                              if cell.subviews.isEmpty, cell.backgroundColor == .black, cell.tag == checkerForFight.tagCell - step {
                                 
                              	 cell.layer.borderWidth = 3
                                 cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                                 cellsForMove.append(cell)
                                 canFight = true
                                 mass.append((checker: queenCheker.tagCheker, cell: cell.tag, checkerBeaten: checkerForFight.tagCheker))
                                   arrayQueen.append((lady: queenCheker.tagCheker, checkerForFight: checkerForFight.tagCheker, cell: cell.tag))
                                 
                                 var nextCell: Int = cell.tag - step
                                 
                                 while nextCell > -1, nextCell < 64 {
                                     var findNextCell: Bool = false
                                     board.subviews.forEach { cell in
                                          if cell.tag == nextCell, cell.subviews.isEmpty, cell.backgroundColor == .black {
                                               
                                        	cell.layer.borderWidth = 3
                                        	cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                                               
                                        	cellsForMove.append(cell)
                                               
                                        	mass.append((checker: queenCheker.tagCheker, cell: cell.tag, checkerBeaten: checkerForFight.tagCheker))
                                               
                                               arrayQueen.append((lady: queenCheker.tagCheker, checkerForFight: checkerForFight.tagCheker, cell: cell.tag))
                                             findNextCell = true
                                             nextCell = nextCell - step
                                         }
                                     }
                                     if findNextCell == false {
                                         nextCell = 65
                                     }
                                 }
                             }
                         }
                     }
                 }
                 
                 a -= 9
                 b -= 7
                 c += 7
                 d += 9
             }
     }
     
     func searchFightBlackQueen(queenChecker: Checker, arrayOfChecker: [Checker]) {
         
             var arrayQueen: [(queen: Int, checkerForFight: Int, cell: Int)] = []
             
             var a = queenChecker.tagCell - 9
             var b = queenChecker.tagCell - 7
             var c = queenChecker.tagCell + 7
             var d = queenChecker.tagCell + 9
             var one = true
             var two = true
             var three =  true
             var four  = true
             
             while a > 0 || b > 0 || c < 63 || d < 63 {
                 
                 arrayOfChecker.forEach { checkerForFight in
                     if checkerForFight.tagCheker < 12  && (checkerForFight.tagCell == a || checkerForFight.tagCell == b || checkerForFight.tagCell == c || checkerForFight.tagCell == d) {
                         
                         var step: Int = 0
                         if (queenChecker.tagCell - checkerForFight.tagCell) < 0, two == true, (queenChecker.tagCell - checkerForFight.tagCell) % 7 == 0 {
                             step = -7
                              two = false
                         }
                         if (queenChecker.tagCell - checkerForFight.tagCell) > 0, three == true, (queenChecker.tagCell - checkerForFight.tagCell) % 7 == 0 {
                             step = 7
                             three = false
                         }
                         if (queenChecker.tagCell - checkerForFight.tagCell) < 0, one == true, (queenChecker.tagCell - checkerForFight.tagCell) % 9 == 0 {
                             step = -9
                              one = false
                         }
                         if (queenChecker.tagCell - checkerForFight.tagCell) > 0, four == true, (queenChecker.tagCell - checkerForFight.tagCell) % 9 == 0 {
                             step = 9
                             four = false
                         }
                         
                         board.subviews.forEach { cell in
                             
                              if cell.subviews.isEmpty, cell.backgroundColor == .black, cell.tag == checkerForFight.tagCell - step {
                                 
                              	cell.layer.borderWidth = 3
                              	cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                              	cellsForMove.append(cell)
                              	canFight = true
                              	mass.append((checker: queenChecker.tagCheker, cell: cell.tag, checkerBeaten: checkerForFight.tagCheker))
                              		arrayQueen.append((queen: queenChecker.tagCheker, checkerForFight: checkerForFight.tagCheker, cell: cell.tag))
                                 
                                 var nextCell: Int = cell.tag - step
                                 
                                 while nextCell > -1, nextCell < 64 {
                                     var findNextCell: Bool = false
                                     board.subviews.forEach { cell in
                                          if cell.tag == nextCell, cell.subviews.isEmpty, cell.backgroundColor == .black {
                                             
                                        	cell.layer.borderWidth = 3
                                        	cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                                        	cellsForMove.append(cell)
                                        	mass.append((checker: queenChecker.tagCheker, cell: cell.tag, checkerBeaten: checkerForFight.tagCheker))
                                               arrayQueen.append((queen: queenChecker.tagCheker, checkerForFight: checkerForFight.tagCheker, cell: cell.tag))
                                             findNextCell = true
                                             nextCell = nextCell - step
                                         }
                                     }
                                     if findNextCell == false {
                                         nextCell = 65
                                     }
                                 }
                             }
                         }
                     }
                 }
                 a -= 9
                 b -= 7
                 c += 7
                 d += 9
             }
     }
     
     func searchFightWhiteChecker(_ arrayOfChecker: [Checker]) {
             arrayOfChecker.forEach { checker in

                 if checker.tagCheker < 12 {
                     if checker.queen == false {
                         arrayOfChecker.forEach { fightChecker in

                              if fightChecker.tagCheker >= 12 && (fightChecker.tagCell == checker.tagCell + 9 || fightChecker.tagCell == checker.tagCell + 7 || fightChecker.tagCell == checker.tagCell - 9 || fightChecker.tagCell == checker.tagCell - 7 ) {
                     
                                 board.subviews.forEach { cell in

                                      if cell.subviews.isEmpty, cell.backgroundColor == .black, cell.tag == checker.tagCell - 2 * (checker.tagCell - fightChecker.tagCell) {
                                           
                                           cell.layer.borderWidth = 3
                                           cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                                           
                                         cellsForMove.append(cell)
                                         canFight = true
                                         mass.append((checker: checker.tagCheker, cell: cell.tag, checkerBeaten: fightChecker.tagCheker))
                                     }
                                 }
                             }
                         }
                     } else {
                          searchFightWhiteQueen(queenCheker: checker, arrayOfChecker: arrayOfChecker)
                     }
                 }
             }
         }
     
     
     func searchFightBlackChecker(_ arrayOfChecker: [Checker]) {
             arrayOfChecker.forEach { checker in

                 if checker.tagCheker >= 12 {
                     if checker.queen == false {
                         arrayOfChecker.forEach { fightChecker in

                             if fightChecker.tagCheker < 12 && (fightChecker.tagCell == checker.tagCell + 9 || fightChecker.tagCell == checker.tagCell + 7 || fightChecker.tagCell == checker.tagCell - 9 || fightChecker.tagCell == checker.tagCell - 7 ) {
                     
                                 board.subviews.forEach { cell in

                                      if cell.subviews.isEmpty, cell.backgroundColor == .black, cell.tag == checker.tagCell - 2 * (checker.tagCell - fightChecker.tagCell) {
                                           
                                           cell.layer.borderWidth = 3
                                           cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                                   
                                         cellsForMove.append(cell)
                                         canFight = true
                                         mass.append((checker: checker.tagCheker, cell: cell.tag, checkerBeaten: fightChecker.tagCheker))
                                     }
                                 }
                             }
                         }
                     } else {
                          searchFightBlackQueen(queenChecker: checker, arrayOfChecker: arrayOfChecker)
                     }
                 }
             }
         }
     
     func checkLady () {
          saveChekers()
          
          let arrayChekers = cellAndChekers
          var num: Int?  = nil
          
          arrayChekers.forEach { checker in
               guard checker.queen == false else {return}
               if (checker.tagCheker <= 12 && (checker.tagCell == 62 || checker.tagCell == 60 || checker.tagCell == 58 || checker.tagCell == 56 )) || (checker.tagCheker > 12 && (checker.tagCell == 1 || checker.tagCell == 3 || checker.tagCell == 5 || checker.tagCell == 7 )) {
                    num = checker.tagCell
                    
               }
          }
          
          
          if let cell = board.subviews.first(where: { $0.tag == num}) {
               cell.subviews.forEach { value in
                    let queen = UIImageView(frame: CGRect(x: 12, y: 12, width: 15, height: 15))
                    queen.layer.cornerRadius = 20
                    queen.image = UIImage(named: "queenWhite")
                    value.addSubview(queen)
               }
          }
     }
     
     func searchLadyMove(for checker: UIView) {
          guard let cell = checker.superview else {return}
            
            let step1: Int = -7
            let step2: Int = -9
            let step3: Int = 7
            let step4: Int = 9
            
            board.subviews.forEach { cellMove in
                 guard cellMove.subviews.isEmpty, cellMove.backgroundColor == .black else { return }
                if cellMove.tag == cell.tag - step1 || cellMove.tag == cell.tag - step2 || cellMove.tag == cell.tag - step3 || cellMove.tag == cell.tag - step4 {
                     cell.layer.borderWidth = 3
                     cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                    cellsForMove.append(cellMove)
                    let step: Int = cell.tag - cellMove.tag
                    var nextCell: Int = cellMove.tag - step
                    
                    while nextCell > -1, nextCell < 64 {
                        var findNextCell: Bool = false
                        board.subviews.forEach { cell in
                             if cell.tag == nextCell, cell.subviews.isEmpty, cell.backgroundColor == .black {
                                 cell.layer.borderWidth = 3
                                 cell.layer.borderColor = UIColor(displayP3Red: 145/255, green: 134/255, blue: 245/255, alpha: 1).cgColor
                                cellsForMove.append(cell)
                                findNextCell = true
                                nextCell = nextCell - step
                            }
                        }
                        if findNextCell == false {
                            nextCell = 65
                        }
                    }
                }
            }
        }
     
    
     func checkWinner () {
     	saveChekers()
          
     	let arrayChekers = cellAndChekers
          
     	var whiteChekers:Int = 0
     	var pinkChekers:Int = 0
     	var winnerPlayer: String = ""
          
          arrayChekers.forEach { cheker in

               
               if cheker.tagCheker < 12 {
                    whiteChekers += 1
               } else {
                    pinkChekers += 1
               }
          
          }
          if whiteChekers == 0 {
               winnerPlayer = playerPink
               let playerss =  Players_Model(
                    name_player1: playerPink,
                    name_player2: playerWhite,
                    won: playerPink,
                    color_cheker_player2: "White",
                    color_cheker_player1: "Pink")

                           players.append(playerss)
               let date = Date()
               dateDormatter.dateFormat = "dd.MM.yy"
               dataGame = dateDormatter.string(from: date)
               
               gameTime = (countTickMin != 0) ? countTickMin * 60 + countTickSec : countTickSec
               
               
               let dateToday = dateDormatter.date(from: dataGame)
               let game = Game_Model(game_time: Int64(gameTime), game_date: dateToday ?? Date() , players: players)
               CoreDataManeger.shared.saveGame(by: game)
          }
          if pinkChekers == 0 {
               winnerPlayer = playerWhite
               
               let playerss =  Players_Model(
                    name_player1: playerPink,
                    name_player2: playerWhite,
                    won: playerWhite,
                    color_cheker_player2: "White",
                    color_cheker_player1: "Pink")

                           players.append(playerss)
               let date = Date()
               dateDormatter.dateFormat = "dd.MM.yy"
               dataGame = dateDormatter.string(from: date)
               
               gameTime = (countTickMin != 0) ? countTickMin * 60 + countTickSec : countTickSec
               
               
               let dateToday = dateDormatter.date(from: dataGame)
               let game = Game_Model(game_time: Int64(gameTime), game_date: dateToday ?? Date() , players: players)
               CoreDataManeger.shared.saveGame(by: game)
          }
          
          if winnerPlayer == "" {
               winnerPlayer = checkMoveCheckers(arrayCheckers: arrayChekers)
          }

          
          if winnerPlayer != "" {
              
     		timer?.invalidate()
          	timer = nil
               if SettingManager.shared.currentLanguage == "en" {
          	pushAlert(with: nil,
          		message: "\(winnerPlayer) Won\nGame time - \(countTickMin) Min : \(countTickSec) Sec",
               	prefferedStyle: .alert,
               	action: UIAlertAction(title: "New game",
                                      style: .default,
                                      handler: { _ in
                                        try? self.fileManager.removeItem(at: self.documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue))
                                        
                                        self.navigationController?.pushViewController(self.getViewController("ViewControllerPlayerOne", 										 nameViewController: "ViewControllerPlayerOne"), animated: true)
                                        
                                      }),
                   
                         UIAlertAction(title: "back menu",
                                       style: .default,
                                       handler: { _ in
                                        	try? self.fileManager.removeItem(at:       self.documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue))
                                             	self.cellAndChekers.removeAll()
                                             	self.removeName()
                                             	self.navigationController?.popToRootViewController(animated: true)
                                        }))
               
               } else {
                    pushAlert(with: nil,
                         message: "\(winnerPlayer) Выиграл",
                         prefferedStyle: .alert,
                         action: UIAlertAction(title: "Новая игра",
                                           style: .default,
                                           handler: { _ in
                                             try? self.fileManager.removeItem(at: self.documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue))
                                             
                                             self.navigationController?.pushViewController(self.getViewController("ViewControllerPlayerOne",                                                    nameViewController: "ViewControllerPlayerOne"), animated: true)
                                             
                                           }),
                        
                              UIAlertAction(title: "в меню",
                                            style: .default,
                                            handler: { _ in
                                                  try? self.fileManager.removeItem(at:       self.documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue))
                                                       self.cellAndChekers.removeAll()
                                                       self.removeName()
                                                       self.navigationController?.popToRootViewController(animated: true)
                                             }))
               }
          }
          
          
         
     }
     
     func localized () {

          
          labelGameTime.text = "label_Game_Time".localized
          buttonBackMainMenu.setTitle("alert_button_back_memnu".localized, for: .normal)
     }
     
     
     
	@objc func timerFunc () {
     
		if countTickSec >= 59 {
     		countTickMin += 1
     		countTickSec = 0
     	}
     
     	countTickSec += 1
     
     	let date = Date()
     	dateDormatter.dateFormat = "dd.MM.yy"
         
         
         if (SettingManager.shared.currentLanguage == "en") {
     		labelTimer.text =  "\(countTickMin) min : \(countTickSec) sec  Today: \(dateDormatter.string(from: date))"
         } else {
          	labelTimer.text =  "\(countTickMin) мин : \(countTickSec) сек  Сегодня: \(dateDormatter.string(from: date))"
         }
	}
     
	@objc func longGesture(_ sender: UILongPressGestureRecognizer) {
		guard let checker = sender.view, (currentChecker == .white && checker.tag < 12) || (currentChecker == .pink && checker.tag >= 12) else { return }
     
     
     	switch sender.state {
         		
     	case .began:
          
          if canFight == false {
          	cellsForMove.removeAll()
          	move(for: checker)
          }
                   
     		UIView.animate(withDuration: 0.3) {
     			checker.transform = (checker.transform.scaledBy(x: 1.5, y: 1.5))
          }
       
      	case .ended:

			UIView.animate(withDuration: 0.3) {
          		checker.transform = .identity
          	}
               
          	if canFight == false {
          		self.board.subviews.forEach { i in
               		i.layer.borderWidth = 0
               	}
          	}
               
     		default:
          		break
               
     	}
     }
     
     
	@objc func punGesture(_ sender: UIPanGestureRecognizer) {
         
		guard let checker = sender.view, (currentChecker == .white && checker.tag < 12) || (currentChecker == .pink && checker.tag >= 12) else { return }
     
         
     	let location = sender.location(in: board)
     	let translation = sender.translation(in: board)
		
        
         

     	switch sender.state {

     		case .changed:

          		guard let cell = sender.view?.superview, let cellOrignin = sender.view?.frame.origin else {return}
          		board.bringSubviewToFront(cell)
          		sender.view?.frame.origin = CGPoint(x: cellOrignin.x + translation.x,
                                             		y: cellOrignin.y + translation.y)

                sender.setTranslation(.zero, in: board)
           
               
          	case .ended:
               	

                            
               var currentCell: UIView? = nil
               var currentBeatenChecker: Int? = nil
               
               
               
               cellsForMove.forEach { cell in
               		if canFight == true {
                    	mass.forEach { tuple in
                    		if checker.tag == tuple.checker, cell.tag == tuple.cell, cell.frame.contains(location) {
                         		currentCell = cell
                              		currentBeatenChecker = tuple.checkerBeaten
                         	}
                         }
                    } else {
                         
                    	if cell.frame.contains(location) {
                    		currentCell = cell
                      	}
                      }
          		}
               sender.view?.frame.origin = CGPoint(x: 5, y: 5)
               guard let newCell = currentCell, let checker = sender.view else {  return }

               		newCell.addSubview(checker)
                           
                    board.subviews.forEach { cell in
                    	cell.subviews.first(where: {$0.tag == currentBeatenChecker})?.removeFromSuperview()
                           }
             
             checkLady()
               
               if canFight == true {
                             
          			canFight = false
               		cellsForMove.removeAll()
                    mass.removeAll()
                    Fight()
                 			
                    self.board.subviews.forEach { i in
                         i.layer.borderWidth = 0
                    }
                    
                    
                    
                    if canFight == true {
                                 
                    	mass.removeAll(where: {$0.checker != checker.tag })

                    		board.subviews.forEach { i in
                         		i.layer.borderWidth = 0
                         	}
                              
                         if mass.isEmpty {
                         	canFight = false
                         }
                    }
               }
                         
               
               
               if canFight == false {
               		currentChecker = currentChecker == .white ? .pink : .white
                    
                    if SettingManager.shared.currentLanguage == "en" {
                         labelName.text = (currentChecker == .white) ? "\(playerWhite)'s turn"  : "\(playerPink)'s turn"
                    } else {
                         labelName.text = (currentChecker == .white) ? "\(playerWhite) ходит"  : "\(playerPink) ходит"
                    }
                    Fight()
               }
             
               checkWinner ()
             
          default:
               break
         }
	}
     
     @IBAction func buttonBack (_ sender: UIButton) {
          timer?.invalidate()
          timer = nil
         
          pushAlert(with: nil,
                    message: "alert_title_save".localized,
                    prefferedStyle: .alert,
                    action: UIAlertAction(title: "alert_button_Yes".localized,
                                          style: .default,
                                          handler: { _ in
                                            self.saveChekers()
                                            self.saveTimeAndCurrentCheker()
                                            self.saveName()
                                            self.cellAndChekers.removeAll()
                                            self.navigationController?.popToRootViewController(animated: true)
                                   
                    }),
                    	UIAlertAction(title:"alert_button_No".localized,
                                          style: .default,
                                          handler: { _ in
                                            try? self.fileManager.removeItem(at: 	self.documentDirectory.appendingPathComponent(Keys.cellAndChekers.rawValue))
                                            self.cellAndChekers.removeAll()
                                            self.removeName()
                                            self.navigationController?.popToRootViewController(animated: true)
                                          }),
                    	UIAlertAction(title: "button_Cancel_Alert".localized,
                                          style: .cancel,
                                          handler: { _ in
                                                     
                                          }))
          
          self.navigationController?.popToRootViewController(animated: true)
     }

     
     


}

extension PlayViewController: UIGestureRecognizerDelegate {
     
     	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          
     		return true
     	}
}


