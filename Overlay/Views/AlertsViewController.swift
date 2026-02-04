import AppKit
import WebKit
import Combine

class AlertsViewController: NSViewController, WKNavigationDelegate {

    private var backgroundView: NSVisualEffectView!
    private var webView: WKWebView!
    private var dragAreaView: AlertsDragAreaView!

    private var cancellables = Set<AnyCancellable>()
    private let settings = AppSettings.shared

    override func loadView() {
        let containerView = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 300))
        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupWebView()
        setupDragArea()
        setupBindings()
        loadAlertsURL()
    }

    // MARK: - Setup

    private func setupBackgroundView() {
        backgroundView = NSVisualEffectView(frame: view.bounds)
        backgroundView.autoresizingMask = [.width, .height]
        backgroundView.wantsLayer = true

        // Apple-style glassmorphic effect
        backgroundView.material = .hudWindow
        backgroundView.blendingMode = .behindWindow
        backgroundView.state = .active
        backgroundView.appearance = NSAppearance(named: .darkAqua)

        // Rounded corners
        backgroundView.layer?.cornerRadius = 12
        backgroundView.layer?.masksToBounds = true

        // Apply opacity
        backgroundView.alphaValue = CGFloat(settings.alertsBackgroundOpacity)

        view.addSubview(backgroundView)
    }

    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.isElementFullscreenEnabled = false

        // Leave space for drag area at top (30px)
        let dragAreaHeight: CGFloat = 30
        let webViewFrame = NSRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: view.bounds.height - dragAreaHeight
        )

        webView = WKWebView(frame: webViewFrame, configuration: configuration)
        webView.autoresizingMask = [.width, .height]
        webView.navigationDelegate = self

        // Transparent background
        webView.setValue(false, forKey: "drawsBackground")
        if #available(macOS 12.0, *) {
            webView.underPageBackgroundColor = .clear
        }

        // Hide scrollbars
        webView.enclosingScrollView?.hasVerticalScroller = false
        webView.enclosingScrollView?.hasHorizontalScroller = false

        view.addSubview(webView)
    }

    private func setupDragArea() {
        // Create a draggable area at the top of the window (30px height)
        dragAreaView = AlertsDragAreaView(frame: NSRect(x: 0, y: view.bounds.height - 30, width: view.bounds.width, height: 30))
        dragAreaView.autoresizingMask = [.width, .minYMargin]
        dragAreaView.gripOpacity = CGFloat(settings.alertsBackgroundOpacity)
        view.addSubview(dragAreaView)
    }

    private func setupBindings() {
        settings.$alertsBackgroundOpacity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] opacity in
                self?.backgroundView.alphaValue = CGFloat(opacity)
                self?.dragAreaView.gripOpacity = CGFloat(opacity)
            }
            .store(in: &cancellables)

        settings.$alertsURL
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadAlertsURL()
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func loadAlertsURL() {
        guard !settings.alertsURL.isEmpty,
              let url = URL(string: settings.alertsURL) else {
            // Load a placeholder if no URL is set
            let html = """
            <html>
            <head>
                <style>
                    body {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        height: 100vh;
                        margin: 0;
                        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                        color: rgba(255, 255, 255, 0.6);
                        text-align: center;
                        background: transparent;
                    }
                    .placeholder {
                        padding: 20px;
                    }
                    h3 {
                        margin: 0 0 10px 0;
                        font-weight: 500;
                    }
                    p {
                        margin: 0;
                        font-size: 14px;
                        opacity: 0.7;
                    }
                </style>
            </head>
            <body>
                <div class="placeholder">
                    <h3>No Alerts URL Set</h3>
                    <p>Open Settings to add your alerts URL</p>
                </div>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
            return
        }

        webView.load(URLRequest(url: url))
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hide scrollbars
        injectScrollbarHidingCSS()
    }

    private func injectScrollbarHidingCSS() {
        let css = """
        ::-webkit-scrollbar { display: none !important; width: 0 !important; height: 0 !important; }
        * { scrollbar-width: none !important; -ms-overflow-style: none !important; }
        html, body { overflow: -moz-scrollbars-none !important; background: transparent !important; }
        """

        let js = """
        var style = document.getElementById('alerts-scrollbar-hide');
        if (!style) {
            style = document.createElement('style');
            style.id = 'alerts-scrollbar-hide';
            document.head.appendChild(style);
        }
        style.textContent = `\(css.replacingOccurrences(of: "\n", with: " "))`;
        """

        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}

// MARK: - Drag Area View

class AlertsDragAreaView: NSView {

    var gripOpacity: CGFloat = 1.0 {
        didSet {
            needsDisplay = true
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }

    override var mouseDownCanMoveWindow: Bool {
        return true
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }

    override func mouseDown(with event: NSEvent) {
        window?.performDrag(with: event)
    }

    override func draw(_ dirtyRect: NSRect) {
        // Hide grip when opacity is 0
        guard gripOpacity > 0 else { return }

        // Draw a subtle grip indicator
        NSColor.white.withAlphaComponent(0.3 * gripOpacity).setFill()

        let gripWidth: CGFloat = 36
        let gripHeight: CGFloat = 5
        let gripRect = NSRect(
            x: (bounds.width - gripWidth) / 2,
            y: (bounds.height - gripHeight) / 2,
            width: gripWidth,
            height: gripHeight
        )

        let path = NSBezierPath(roundedRect: gripRect, xRadius: 2.5, yRadius: 2.5)
        path.fill()
    }
}
