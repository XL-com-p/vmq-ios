import Foundation

class NetworkService {

    static let shared = NetworkService()

    private init() {}

    // MARK: - MD5 加密
    private func md5(_ string: String) -> String {
        guard !string.isEmpty else { return "" }

        let data = Data(string.utf8)
        var hash = [UInt8](repeating: 0, count: 16)

        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(data.count), &hash)
        }

        return hash.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - 验证配置
    func verifyConfig(host: String, key: String, completion: @escaping (Bool, String?) -> Void) {
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
        let sign = md5("\(timestamp)\(key)")
        let urlString = "http://\(host)/appHeart?t=\(timestamp)&sign=\(sign)"

        guard let url = URL(string: urlString) else {
            completion(false, "URL格式错误")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true, "配置验证成功")
            } else {
                completion(false, "服务器响应错误")
            }
        }.resume()
    }

    // MARK: - 发送心跳
    func sendHeartbeat(host: String, key: String, completion: @escaping (Bool, String?) -> Void) {
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
        let sign = md5("\(timestamp)\(key)")
        let urlString = "http://\(host)/appHeart?t=\(timestamp)&sign=\(sign)"

        guard let url = URL(string: urlString) else {
            completion(false, "URL格式错误")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(true, "心跳返回：\(responseString)")
            } else {
                completion(true, "心跳正常")
            }
        }.resume()
    }

    // MARK: - 推送收款通知（由服务端回调触发）
    func sendPaymentNotification(type: Int, price: Double, host: String, key: String, completion: @escaping (Bool) -> Void) {
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
        let sign = md5("\(type)\(Int(price))\(timestamp)\(key)")
        let urlString = "http://\(host)/appPush?t=\(timestamp)&type=\(type)&price=\(Int(price))&sign=\(sign)"

        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}

// MARK: - CommonCrypto Import
import CommonCrypto