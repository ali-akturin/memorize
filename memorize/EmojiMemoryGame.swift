//
//  EmojiMemoryGame.swift
//  memorize
//
//  Created by Ali Akturin on 1/30/22.
//

import SwiftUI
import Combine

class EmojiMemoryGame: ObservableObject {
    
    static var themes = [(0, "Smileys", Color.yellow),
                         (1, "Halloween",Color.black),
                         (2, "Animals",Color.green),
                         (3, "Hand gestures",Color.yellow),
                         (4, "Faces",Color.pink),
                         (5, "Attires",Color.blue)]
    
    public static var themeName: String?
    public static var themeColor: Color?
    
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame(themeIndex: Int.random(in: 0..<6))
     
    static func createMemoryGame(themeIndex: Int) -> MemoryGame<String> {
        
        var emojis_ = [String]()
        var emojis = [String]()
        let emojisSize = Int.random(in: 2..<6)

        themeName = themes[themeIndex].1
        themeColor = themes[themeIndex].2

        switch themeIndex {
        case 1:
            emojis_ = ["👻","💀","🎃","🕷","🕸","🦇"]
        case 2:
            emojis_ = ["🐵","🦁","🐹","🐸","🐻","🐮"]
        case 3:
            emojis_ = ["🙌","🖐","☝️","💪","🤟","✊"]
        case 4:
            emojis_ = ["👦","👳‍♂️","👲","👩‍🦳","🧑‍🦰","👴"]
        case 5:
            emojis_ = ["👚","🦺","👖","👗","👔","👘"]
        default:
            emojis_ = ["😀","😃","😂","😍","🥸","😡"]
        }

        emojis_.shuffle()

        for emoji in emojis_{

            if emojis.count < emojisSize {
                emojis.append(emoji)
            }
        }
        
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the model
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        objectWillChange.send()
        model.choose(card: card, score: 0)
    }
    
    // MARK: - Start new game
    func startNewGame() {
        let themeIndex = Int.random(in: 0..<6)
        model = EmojiMemoryGame.createMemoryGame(themeIndex: themeIndex)
    }
    
    // MARK: - Get the theme name
    func getThemeName() -> String {
        return EmojiMemoryGame.themeName ?? "Something went wrong"
    }
    
    // MARK: - Get the theme color
    func getThemeColor() -> (color: Color, gcolor: LinearGradient?)   {
        let colors = Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple])
        let conic = LinearGradient(gradient: colors, startPoint: .top, endPoint: .bottom)
        return (EmojiMemoryGame.themeColor ?? Color.white, conic)
    }
    
    // MARK: - Return the score
    func returnScore() -> Int {
        return model.returnScore()
    }
}
