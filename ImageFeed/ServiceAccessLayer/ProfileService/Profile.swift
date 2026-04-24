struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?

    init(from result: ProfileResult) {
        username = result.username
        name = [result.firstName, result.lastName].joined(separator: " ")
        loginName = "@\(result.username)"
        bio = result.bio
    }
}
