# <a href="https://itunes.apple.com/us/app/avocado/id1370443662?mt=8"><img src="/Screenshots/icon.png" width="50" height="50"/></a> Avocado

- Hangul(Korean letter)-tracing + Heads-up [demo](https://www.youtube.com/watch?v=Z6dEGXyNk7M)

<p align="center"><a href="https://itunes.apple.com/us/app/avocado/id1370443662?mt=8"><img src="Screenshots/app-store-badge.png" width="200" /></a></p>


## Motive

- When my nephew started to learn language, she practiced writing her name at first
- However existing apps for learning to write language have a few problems. For example, users have to write only default words that the app provides
- I wanted my nephew to practice writing any words that she wants to learn
- I wanted my nephew write the word "Mom" with her mom's photo


## Features

- Add custom word cards with your photos
- Play heads-up game with your word cards using CoreMotion
- Trace korean letter of your word cards
- Listen and repeat korean letter of your word cards
- Categorize your word cards
- Enjoy your video captured while playing Heads-up


![Alt text](/Screenshots/allshot.jpg)


## Architecture

- LocalService <-> ViewModel <-> ViewController
- CategoryView : Categorize custom word cards
- CardView : Word Card list per category
- PopCardView : Flip word card to get the word of photo
- TracingView : Practice tracing the letter of the word and listen the sound of the letter
- GameView : Play Heads-up game with your custom word cards, and enjoy the video captured while doing the game


## Dependency

- SnapKit
- RealmSwift/RxRealm
- RxSwift
- RxCocoa
- Action
- RxGesture
