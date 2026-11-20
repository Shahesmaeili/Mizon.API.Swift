import MizonAPI

public struct MusicCommentTagSearchResponse: IApiResponse {
    public var tags: [MusicCommentTagItem]

    public init(tags: [MusicCommentTagItem] = []) {
        self.tags = tags
    }
}
