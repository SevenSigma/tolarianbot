import Foundation
import TelegramBotSDK
import Alamofire

let token = readToken(from: "tolarianbotToken")
let bot = TelegramBot(token: token)

// Bot main loop. Gets updates and sends replies
while let update = bot.nextUpdateSync() {

//    This deals with queries sent to the bot via its inline mode (e.g.: "@tolarianbot Garruk")
    if let query = update.inlineQuery?.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        print("Inline query received: \(query)")
//        Sends the search terms to the Scryfall API
        AF.request("https://api.scryfall.com/cards/search?q=\(query)").responseJSON(completionHandler: { response in
            debugPrint(response)
        })
            }
}

fatalError("Server stopped due to error: \(String(describing: bot.lastError))")
