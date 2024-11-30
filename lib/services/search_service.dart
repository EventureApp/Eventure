class SearchService {
  static int search(String text, String pattern) {
    int n = text.length;
    int m = pattern.length;

    for (int i = 0; i <= n - m; i++) {
      int j;
      for (j = 0; j < m; j++) {
        if (text[i + j] != pattern[j]) break;
      }
      if (j == m) return i;
    }
    return 0;
  }
}
