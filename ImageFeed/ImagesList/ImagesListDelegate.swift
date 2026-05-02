protocol ImagesListDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
    func imageListCellDidFinishLoading(_ cell: ImagesListCell)
}
