import Foundation

public enum MizonJSON {
    public static func iso8601String(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
    public static func encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var c = encoder.singleValueContainer()
            try c.encode(iso8601String(from: date))
        }
        return encoder
    }
    public static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .custom { keys in
            let original = keys.last!.stringValue
            return JSONKey(stringValue: canonicalKeys[original.lowercased()] ?? original)
        }
        decoder.dateDecodingStrategy = .custom { decoder in
            let c = try decoder.singleValueContainer()
            let value = try c.decode(String.self)
            let fractional = ISO8601DateFormatter(); fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let simple = ISO8601DateFormatter()
            guard let date = fractional.date(from: value) ?? simple.date(from: value) else {
                throw DecodingError.dataCorruptedError(in: c, debugDescription: "Invalid ISO8601 date")
            }
            return date
        }
        return decoder
    }
    private static let canonicalKeys: [String: String] = [
        "accentcolorhex": "accentColorHex",
        "accesstoken": "accessToken",
        "apirequest": "apiRequest",
        "blurhash": "blurhash",
        "category": "category",
        "chunksize": "chunkSize",
        "client": "client",
        "clientpublicid": "clientPublicId",
        "closebuttontext": "closeButtonText",
        "code": "code",
        "containscurrentmusic": "containsCurrentMusic",
        "content": "content",
        "contentmediapublicid": "contentMediaPublicId",
        "contributors": "contributors",
        "count": "count",
        "covermediapublicid": "coverMediaPublicId",
        "creatorclientpublicid": "creatorClientPublicId",
        "creatorfirstname": "creatorFirstName",
        "creatorlastname": "creatorLastName",
        "creatorprofilemediapublicid": "creatorProfileMediaPublicId",
        "creatorusername": "creatorUsername",
        "details": "details",
        "duration": "duration",
        "emailaddress": "emailAddress",
        "emailaddressisverified": "emailAddressIsVerified",
        "emoji": "emoji",
        "endtimeinmilliseconds": "endTimeInMilliseconds",
        "error": "error",
        "expiredatetime": "expireDateTime",
        "filehash": "fileHash",
        "filename": "fileName",
        "filesize": "fileSize",
        "firstname": "firstName",
        "height": "height",
        "iconsymbol": "iconSymbol",
        "instrumentalmediapublicid": "instrumentalMediaPublicId",
        "isavailable": "isAvailable",
        "isclipping": "isClipping",
        "isfromcache": "isFromCache",
        "isplaying": "isPlaying",
        "itemtype": "itemType",
        "languagepersiantitle": "languagePersianTitle",
        "languagepublicid": "languagePublicId",
        "languagetitle": "languageTitle",
        "lastmusiccovermediapublicid": "lastMusicCoverMediaPublicId",
        "lastname": "lastName",
        "lightingprofile": "lightingProfile",
        "liked": "liked",
        "likedbyme": "likedByMe",
        "likescount": "likesCount",
        "lineorder": "lineOrder",
        "maximumamplitude": "maximumAmplitude",
        "meprofile": "meProfile",
        "mediapublicid": "mediaPublicId",
        "minimumamplitude": "minimumAmplitude",
        "mizonhuburl": "mizonHubURL",
        "music": "music",
        "musicalbum": "musicAlbum",
        "musiccommentpublicid": "musicCommentPublicId",
        "musiccomments": "musicComments",
        "musiccontributortypepersiantitle": "musicContributorTypePersianTitle",
        "musiccontributortypepublicid": "musicContributorTypePublicId",
        "musiccontributortypetitle": "musicContributorTypeTitle",
        "musiccover": "musicCover",
        "musicfilepublicid": "musicFilePublicId",
        "musicgenretypes": "musicGenreTypes",
        "musicgenres": "musicGenres",
        "musiclabel": "musicLabel",
        "musiclanguages": "musicLanguages",
        "musiclyriclanguages": "musicLyricLanguages",
        "musiclyriclinewords": "musicLyricLineWords",
        "musiclyriclines": "musicLyricLines",
        "musiclyricpublicid": "musicLyricPublicId",
        "musicplaylistpublicid": "musicPlaylistPublicId",
        "musicplaylistpublicids": "musicPlaylistPublicIds",
        "musicplaylists": "musicPlaylists",
        "musicpublicid": "musicPublicId",
        "musicreactionitems": "musicReactionItems",
        "musicreactiontypepublicid": "musicReactionTypePublicId",
        "musicreactiontypes": "musicReactionTypes",
        "musics": "musics",
        "musicscount": "musicsCount",
        "nickname": "nickName",
        "offsetinmilliseconds": "offsetInMilliseconds",
        "password": "password",
        "peak": "peak",
        "persiantitle": "persianTitle",
        "personpublicid": "personPublicId",
        "positionmilliseconds": "positionMilliseconds",
        "previewmediapublicid": "previewMediaPublicId",
        "primaryaccentcolor": "primaryAccentColor",
        "primarycolor": "primaryColor",
        "profilemediapublicid": "profileMediaPublicId",
        "publicid": "publicId",
        "query": "query",
        "reacted": "reacted",
        "reactedbyme": "reactedByMe",
        "refreshtoken": "refreshToken",
        "releasedatetime": "releaseDateTime",
        "rms": "rms",
        "rotation": "rotation",
        "sessionpublicid": "sessionPublicId",
        "starttimeinmilliseconds": "startTimeInMilliseconds",
        "storagepath": "storagePath",
        "stories": "stories",
        "storycontenttypepersiantitle": "storyContentTypePersianTitle",
        "storycontenttypepublicid": "storyContentTypePublicId",
        "storycontenttypetitle": "storyContentTypeTitle",
        "storypublicid": "storyPublicId",
        "storywidgetstylepublicid": "storyWidgetStylePublicId",
        "storywidgettypepublicid": "storyWidgetTypePublicId",
        "text": "text",
        "timestamp": "timestamp",
        "title": "title",
        "totalchunks": "totalChunks",
        "transient": "transient",
        "updatedatutc": "updatedAtUtc",
        "username": "username",
        "viewedbyme": "viewedByMe",
        "viewscount": "viewsCount",
        "vocalsmediapublicid": "vocalsMediaPublicId",
        "waveforms": "waveforms",
        "widgets": "widgets",
        "width": "width",
        "wordorder": "wordOrder",
        "x": "x",
        "y": "y",
        "zindex": "zIndex",
    ]
    private struct JSONKey: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }
        init(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { return nil }
    }
}
