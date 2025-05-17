import UIKit

class FeedNewZaloVM {

    private(set) var posts: [PostModel] = []
    private(set) var filteredPosts: [PostModel] = []
    private(set) var isExpandedStates: [Bool] = []

    private var isFiltering = false

    init() {
        loadPosts()
    }

    private func loadPosts() {
        posts = [
            PostModel(
                avatar: UIImage(named: "a1") ?? UIImage(systemName: "person.circle")!,
                username: "Nguyễn Thảo Nhi",
                time: "27 minutes ago",
                text: "Một ngày tuyệt đẹp tại Đà Lạt, không khí se lạnh, cà phê thơm và hoa nở rộ khắp nơi!",
                images: [UIImage(named: "img1")!, UIImage(named: "img2")!],
                linkTitle: "vnexpress.net",
                linkSubtitle: "Du lịch Đà Lạt bùng nổ dịp lễ, khách sạn kín phòng",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a2")!,
                username: "Nguyễn Thảo Nhi",
                time: "1 hour ago",
                text: "Mình vừa hoàn thành xong dự án thiết kế nội thất cho căn hộ nhỏ 40m². Cảm giác thật sự mãn nguyện!",
                images: [UIImage(named: "img3")!],
                linkTitle: "kenh14.vn",
                linkSubtitle: "Căn hộ nhỏ 40m² biến hóa với phong cách Bắc Âu",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a3")!,
                username: "Nguyễn Thảo Nhi",
                time: "2 hours ago",
                text: "Vừa được thăng chức trưởng nhóm marketing! Cảm ơn những người đã luôn tin tưởng và đồng hành cùng mình.",
                images: [],
                linkTitle: "",
                linkSubtitle: "",
                videoName: "6611133798667"
            ),
            PostModel(
                avatar: UIImage(named: "a4")!,
                username: "Nguyễn Thảo Nhi",
                time: "3 hours ago",
                text: "Check-in sự kiện công nghệ tại TP.HCM. Nhiều điều thú vị và đầy cảm hứng!",
                images: [UIImage(named: "img2")!, UIImage(named: "img4")!],
                linkTitle: "techz.vn",
                linkSubtitle: "Hội nghị TechX Summit 2025 chính thức khai mạc",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a1")!,
                username: "Lê Hồng Nhung",
                time: "5 hours ago",
                text: "Mỗi sáng thức dậy là một cơ hội mới để phát triển bản thân. Cố gắng mỗi ngày nhé 💪",
                images: [],
                linkTitle: "",
                linkSubtitle: "",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a2")!,
                username: "Lê Hồng Nhung",
                time: "6 hours ago",
                text: "Đà Nẵng thật sự là thành phố đáng sống, đồ ăn ngon, con người thân thiện!",
                images: [UIImage(named: "img1")!, UIImage(named: "img3")!],
                linkTitle: "",
                linkSubtitle: "",
                videoName: "6611133848760"
            ),
            PostModel(
                avatar: UIImage(named: "a3")!,
                username: "Lê Hồng Nhung",
                time: "Yesterday",
                text: "Vừa nhận học bổng toàn phần chương trình Thạc sĩ tại Pháp. Một hành trình mới đang bắt đầu 🇫🇷",
                images: [],
                linkTitle: "scholarships.fr",
                linkSubtitle: "Học bổng toàn phần du học Pháp 2025",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a4")!,
                username: "Phạm Bảo Hân",
                time: "Yesterday",
                text: "Mình đã bắt đầu viết nhật ký mỗi ngày. Cảm giác được sống chậm lại, hiểu bản thân hơn 🌿",
                images: [],
                linkTitle: "",
                linkSubtitle: "",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a1")!,
                username: "Phạm Bảo Hân",
                time: "2 days ago",
                text: "Tối nay nấu món bún riêu cua cho cả nhà, ai cũng khen ngon 🥰",
                images: [UIImage(named: "img4")!],
                linkTitle: "afamily.vn",
                linkSubtitle: "Cách nấu bún riêu cua chuẩn vị miền Bắc",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a2")!,
                username: "Phạm Bảo Hân",
                time: "3 days ago",
                text: "Làm mẹ là hành trình đầy yêu thương và cũng đầy thử thách. Mỗi ngày là một món quà 💕",
                images: [],
                linkTitle: "",
                linkSubtitle: "",
                videoName: "6611133798667"
            ),
            PostModel(
                avatar: UIImage(named: "a3")!,
                username: "Phạm Bảo Hân",
                time: "30 minutes ago",
                text: "Hôm nay trời đẹp quá, tranh thủ dắt mèo đi dạo 🐱🌞",
                images: [UIImage(named: "img1")!, UIImage(named: "img4")!],
                linkTitle: "",
                linkSubtitle: "",
                videoName: ""
            ),
            PostModel(
                avatar: UIImage(named: "a3")!,
                username: "Đoàn Mỹ Linh",
                time: "4 hours ago",
                text: "Làm vlog hướng dẫn makeup tự nhiên, ai xem rồi góp ý giúp mình với nhé 💄",
                images: [],
                linkTitle: "youtube.com",
                linkSubtitle: "Makeup nhẹ nhàng cho ngày nắng đẹp",
                videoName: "6611133888122"
            ),
            PostModel(
                avatar: UIImage(named: "a3")!,
                username: "Đoàn Mỹ Linh",
                time: "2 days ago",
                text: "Thử thách không dùng mạng xã hội trong 24 giờ. Bạn có dám thử? 📵",
                images: [],
                linkTitle: "",
                linkSubtitle: "",
                videoName: ""
            )
        ]

        isExpandedStates = Array(repeating: false, count: posts.count)
        filteredPosts = posts
    }

    func filterPosts(with keyword: String) {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            isFiltering = false
            filteredPosts = posts
        } else {
            isFiltering = true
            filteredPosts = posts.filter {
                $0.username.localizedCaseInsensitiveContains(trimmed) ||
                $0.text.localizedCaseInsensitiveContains(trimmed)
            }
        }
        isExpandedStates = Array(repeating: false, count: filteredPosts.count)
    }

    func numberOfRows() -> Int {
        return 2 + filteredPosts.count
    }

    func post(at index: Int) -> PostModel? {
        let postIndex = index - 2
        guard postIndex >= 0 && postIndex < filteredPosts.count else { return nil }
        var post = filteredPosts[postIndex]
        post.isExpandedStates = isExpandedStates[postIndex]
        return post
    }

    func toggleExpandState(at index: Int) {
        let postIndex = index - 2
        guard postIndex >= 0 && postIndex < isExpandedStates.count else { return }
        isExpandedStates[postIndex].toggle()
        filteredPosts[postIndex].isExpandedStates = isExpandedStates[postIndex]
    }

    func snapshotItems() -> [SnapshotItem] {
        let femaleNames = [
            "Nguyễn Thảo Nhi", "Nguyễn Thảo My", "Nguyễn Thu Thảo",
            "Vũ Bảo Hân", "Lý Thị Hồng Nhung", "Nguyễn Thị Trúc Mai",
            "Lê Hồng Nhung", "Đinh Thị Mỹ Hạnh"
        ]

        let femaleAvatars = [
            UIImage(named: "a1")!,
            UIImage(named: "a2")!,
            UIImage(named: "a3")!,
            UIImage(named: "a4")!
        ]

        let femaleIMG = [
            UIImage(named: "img1")!,
            UIImage(named: "img2")!,
            UIImage(named: "img3")!,
            UIImage(named: "img4")!
        ]

        var snapshotData = [SnapshotItem]()
        for i in 0..<femaleAvatars.count {
            snapshotData.append(SnapshotItem(image: femaleIMG[i], avatar: femaleAvatars[i], name: femaleNames[i]))
        }
        return snapshotData
    }
    
    // MARK: - Load More (append data cũ vào)
    func loadMorePosts(completion: (() -> Void)? = nil) {
        // Append chính posts hiện tại vào posts (data cũ)
        let morePosts = posts
        posts.append(contentsOf: morePosts)
        
        // Nếu không đang filter thì append filteredPosts luôn
        if !isFiltering {
            filteredPosts.append(contentsOf: morePosts)
        }
        // Cập nhật trạng thái expand
        isExpandedStates.append(contentsOf: Array(repeating: false, count: morePosts.count))
        
        completion?()
    }
}

