import MizonAPI

public struct RegisterRequest: IApiRequest {
    public var firstName: String
    public var lastName: String
    public var username: String
    public var emailAddress: String
    public var password: String

    public init(firstName: String, lastName: String, username: String, emailAddress: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.emailAddress = emailAddress
        self.password = password
    }
}
