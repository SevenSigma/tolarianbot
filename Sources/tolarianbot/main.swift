import Foundation
import TelegramBotSDK
import Alamofire

let token = readToken(from: "tolarianbotToken")
let bot = TelegramBot(token: token)
var query = String()

// Bot main loop. Gets updates and sends replies
while let update = bot.nextUpdateSync() {
//    This part deals with messages sent directly to a chat window with the bot
    if let message = update.message,
        let from = message.from,
        let text = message.text {
//      TODO: Change the message the user gets from interacting with the bot to something more useful
        bot.sendMessageAsync(chatId: from.id,
                             text: "Hi \(from.firstName)! You said: \(text).\n")
    }
//    This deals with queries sent to the bot via its inline mode (e.g.: "@tolarianbot Garruk")
    if let query = update.inlineQuery?.query {
        print("Inline query received")
            }
}

func searchScryfall (parameters: Parameters) {
    let parameters = ["foo", "bar"]
    AF.request("https://api.scryfall.com").responseJSON(completionHandler: { response in
        debugPrint(response)
        let searchResult = response.data
    })
}

fatalError("Server stopped due to error: \(String(describing: bot.lastError))")