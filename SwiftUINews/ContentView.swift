import SwiftUI

struct ContentView: View {
	
	@State var articles: [Article] = []
	
    var body: some View {
		NavigationView {
			List(articles) {
				CardView(article: $0)
			}
			.navigationBarTitle("Articles")
			.onAppear {
				NewsRequest(urlString: Constants.newsFetchUrl)?.send() { items in
					self.articles = items
				}
			}
		}
    }
	
}

struct CardView: View {
	
	var article: Article
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			URLImage(article.thumbnail ?? "").scaledToFill()
			Text(article.headline)
				.font(.title)
				.lineLimit(3)
			Text(article.byLine)
				.foregroundColor(.secondary)
				.font(.subheadline)
			HStack(alignment: .firstTextBaseline) {
			
				ForEach(article.tags, id: \.self) { tag in	Text(tag).background(Color.green).foregroundColor(.white).cornerRadius(4)
				}
			}
			Text(article.abstract)
				.font(.body)
			.lineLimit(10)
			
			}
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let articles = [Article.test, Article.test, Article.test]
		return ContentView(articles: articles)
    }
}

#endif
