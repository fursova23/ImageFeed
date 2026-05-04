extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
          var result = self
          result[index] = newValue
          return result
      }
}
