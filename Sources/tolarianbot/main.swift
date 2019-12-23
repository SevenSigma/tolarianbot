import Foundation
import TelegramBotSDK
import Alamofire
import SwiftyJSON

let token = readToken(from: "tolarianbotToken")
let bot = TelegramBot(token: token)

// Bot main loop. Gets updates and sends replies
while let update = bot.nextUpdateSync() {

//    This deals with queries sent to the bot via its inline mode (e.g.: "@tolarianbot Garruk")
    let queryID = update.inlineQuery?.id
    if let query = update.inlineQuery?.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        print("Inline query received: ID \(String(describing: queryID)) - \(query)")
        
//        Sends the search terms to the Scryfall API
        AF.request("https://api.scryfall.com/cards/search?q=\(query)").responseJSON(completionHandler: { response in
            
//            Constructs a json SwiftyJSON object from Scryfall's response
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(_):
                let json = try? JSON(data: response.data!)
                
//                Variables that will comprise the bot's response
                var cardResult:InlineQueryResultPhoto = InlineQueryResultPhoto.init()
                var inlineBotResponse:[InlineQueryResultPhoto] = []
                
//                Extracts relevant data from the constructed json
                for card in json!["data"].arrayValue {
                    let cardID = card["id"].string
                    let bigImage = card["image_uris"]["large"].string
                    let smallImage = card["image_uris"]["small"].string
                            
//                 Builds the results that the bot will show inline
                    cardResult.typeString = "photo"
                    cardResult.id = cardID ?? "none"
                    cardResult.photoUrl = bigImage ?? "none"
                    cardResult.thumbUrl = smallImage ?? "none"

                    inlineBotResponse.append(cardResult)
                        
                }
//                Sends the bot's response

                bot.answerInlineQuerySync(inlineQueryId: queryID!, results:inlineBotResponse)
            }
        })
    }
}

fatalError("Server stopped due to error: \(String(describing: bot.lastError))")
