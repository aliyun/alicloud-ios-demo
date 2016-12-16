# HTTPDNS iOS Demo

该Demo提供了App不同应用场景集成HTTPDNS服务的示例。

Demo仅作为原理讲解和示例代码用途，
强烈建议在搞清楚各场景下HTTPDNS接入实现细节和原理后，再集成到App线上环境。

## 1. 普通场景
- 基于网络API NSURLSession/NSURLConnection发送HTTP请求；
- 相关示例代码:
    - ViewController

## 2. WebView场景
- WebView发起的HTTP网络请求，通过注册的NSURLProtocol拦截后处理；
- 相关示例代码:
    - WebViewController
    - WebViewURLProtocol

## 3. HTTPS场景

### 3.1 普通HTTPS请求

- 基于网络API NSURLSession/NSURLConnection发送HTTPS请求；
- 相关示例代码:
    - HTTPSSceneViewController

### 3.2 SNI场景HTTPS请求
- 基于WebView/NSURLSession/NSURLConnection发送的HTTPS（SNI场景）网络请求，
经过注册的NSURLProtocol拦截后，基于CFNetwork发出网络请求。
- 相关示例代码：
    - SNIViewController
    - CFHTTPDNSRequestTaskDelegate
    - CFHTTPDNSHTTPProtocol
    - CFHTTPDNSRequestTask

