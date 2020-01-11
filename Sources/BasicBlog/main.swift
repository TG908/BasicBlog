import Foundation
import Publish
import Plot
import PygmentsPublishPlugin

// This type acts as the configuration for your website.
struct BasicBlog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case about
        case links
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://gymni.ch")!
    var name = "llvm::BasicBlog"
    var description = "A blog about compilers and programming languages"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try BasicBlog().publish(withTheme: .basicBlog,
                        deployedUsing: .gitHub("tg908/tg908.github.io", useSSH: true),
                        plugins: [.pygmentize(withClassPrefix: "")]
)
