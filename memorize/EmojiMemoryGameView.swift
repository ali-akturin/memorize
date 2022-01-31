//
//  EmojiMemoryGameView.swift
//  memorize
//
//  Created by Ali Akturin on 1/30/22.
//

import SwiftUI

let game = EmojiMemoryGame()

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Theme: " + self.viewModel.getThemeName())
                .fontWeight(.bold)
                .font(.title3)
                .padding()
                .background(Color.white)
                .cornerRadius(50)
                .foregroundColor(.black)
            
            Text("Score: " + String(self.viewModel.returnScore()))
                .font(.title3)
                .background(Color.white)
                .foregroundColor(.black)
            
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture{
                    withAnimation(.linear(duration: 0.5)){
                        self.viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(game.getThemeColor().color)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.viewModel.startNewGame()
                }
            }, label: {
                if(game.getThemeName() == "Smileys"){
                    Text("Start new game")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(game.getThemeColor().gcolor)
                    .cornerRadius(40)
                    .foregroundColor(Color.white)
                } else {
                    Text("Start new game")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(game.getThemeColor().color)
                    .cornerRadius(40)
                    .foregroundColor(Color.white)
                }
            })
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) ->  some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockWise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockWise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.scale)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
        
        if game.getThemeName() == "Smileys"{
            if !card.isFaceUp && !card.isMatched {
                let colors = Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple])
                LinearGradient(gradient: colors, startPoint: .top, endPoint: .bottom)
            }
        }
    }
    
    // MARK: - Drawing Constants
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        return EmojiMemoryGameView(viewModel: EmojiMemoryGame.init())
        return EmojiMemoryGameView(viewModel: game)
    }
}

