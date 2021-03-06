//
//  GameOverPopup.swift
//  SideScroller
//
//  Created by Eric Gustin on 7/22/20.
//  Copyright © 2020 Eric Gustin. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameOverPopup : UIView, GKGameCenterControllerDelegate {
  
  let LEADERBOARD_ID = "com.eric.SwipeyBird"
  
  private let container: UIView = {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = UIColor(red: 253/255, green: 217/255, blue: 181/255, alpha: 1.0)
    container.layer.cornerRadius = 12
    container.layer.borderColor = UIColor.black.cgColor
    container.layer.borderWidth = 1.0
    
    return container
  }()
  
  private let scoreLabel: UILabel = {
    let label = UILabel()
    label.text = "SCORE: "
    label.font = UIFont(name: "Cartooncookies", size: 25)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let bestScoreLabel: UILabel = {
    let label = UILabel()
    label.text = "BEST SCORE: "
    label.font = UIFont(name: "Cartooncookies", size: 25)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let restartButton: UIButton = {
    let button = UIButton()
    button.setTitle("RESTART", for: .normal)
    button.titleLabel?.font = UIFont(name: "Cartooncookies", size: 32)
    button.setTitleColor(.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let leaderboardButton: UIButton = {
    let button = UIButton()
    button.setTitle("LEADERBOARD", for: .normal)
    button.titleLabel?.font = UIFont(name: "Cartooncookies", size: 32)
    button.setTitleColor(.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private var score: Int?
  private lazy var bestScore = UserDefaults.standard.integer(forKey: "bestScore")
  
  private var containerInitialHeight: NSLayoutConstraint = NSLayoutConstraint()
  
  required init(score: Int?) {
    super.init(frame: .zero)
    self.score = score
    postInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    postInit()
  }
  
  private func postInit() {
    self.frame = UIScreen.main.bounds
    self.backgroundColor = UIColor.white.withAlphaComponent(0.0)
    checkIfNewBestScore()
    setUpSubviews()
    animateIn()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func checkIfNewBestScore() {
    if UserDefaults.standard.integer(forKey: "bestScore") < self.score ?? 0 {
      UserDefaults.standard.set(score, forKey: "bestScore")
    }
  }
  
  private func setUpSubviews() {
    self.addSubview(container)
    
    scoreLabel.text?.append("\(score ?? 0)")
    container.addSubview(scoreLabel)
    scoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    scoreLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3*UIScreen.main.bounds.height/8).isActive = true
    
    bestScoreLabel.text?.append("\(bestScore)")
    container.addSubview(bestScoreLabel)
    bestScoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    bestScoreLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10).isActive = true

    restartButton.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
    container.addSubview(restartButton)
    restartButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    restartButton.topAnchor.constraint(equalTo: bestScoreLabel.bottomAnchor, constant: 10).isActive = true

    leaderboardButton.addTarget(self, action: #selector(leaderboardButtonClicked), for: .touchUpInside)
    container.addSubview(leaderboardButton)
    leaderboardButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    leaderboardButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 10).isActive = true
    
    container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    container.topAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: -10).isActive = true
    container.bottomAnchor.constraint(equalTo: leaderboardButton.bottomAnchor, constant: 10).isActive = true
    container.leadingAnchor.constraint(equalTo: leaderboardButton.leadingAnchor, constant: -10).isActive = true
    container.trailingAnchor.constraint(equalTo: leaderboardButton.trailingAnchor, constant: 10).isActive = true
    
  }
  
  @objc func leaderboardButtonClicked() {
    let gcVC = GKGameCenterViewController()
    gcVC.gameCenterDelegate = self
    gcVC.viewState = .leaderboards
    gcVC.leaderboardIdentifier = LEADERBOARD_ID
    
    findViewController()?.present(gcVC, animated: true, completion: nil)
  }
  
  private func animateIn() {
    container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height/12)
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
      self.container.transform = .identity
    }, completion: nil)
  }
  
  @objc func animateOut() {
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
      self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height/12)
      self.alpha = 0
    }) { (complete) in
      if complete {
        self.removeFromSuperview()
        game.isOver = true
      }
    }
  }
  
  
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
