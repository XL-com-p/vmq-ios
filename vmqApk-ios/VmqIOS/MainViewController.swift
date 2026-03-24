import UIKit
import AVFoundation

class MainViewController: UIViewController {

    // MARK: - Properties
    private var host: String = ""
    private var key: String = ""
    private var isConfigured: Bool = false

    // UI 组件
    private let hostLabel = UILabel()
    private let keyLabel = UILabel()
    private let statusLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    private let manualButton = UIButton(type: .system)
    private let heartButton = UIButton(type: .system)
    private let testButton = UIButton(type: .system)
    private var heartTimer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadConfig()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopHeartbeat()
    }

    // MARK: - UI Setup
    private func setupUI() {
        title = "V免签 iOS 监控端"
        view.backgroundColor = .systemBackground

        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "V免签开源免费免签系统"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // 版本标签
        let versionLabel = UILabel()
        versionLabel.text = "v1.0 (iOS版)"
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textColor = .secondaryLabel
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)

        // 主机地址标签
        hostLabel.text = "通知地址：未配置"
        hostLabel.font = UIFont.systemFont(ofSize: 16)
        hostLabel.textColor = .label
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostLabel)

        // 密钥标签
        keyLabel.text = "通讯密钥：未配置"
        keyLabel.font = UIFont.systemFont(ofSize: 16)
        keyLabel.textColor = .label
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyLabel)

        // 状态标签
        statusLabel.text = "状态：未连接"
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = .systemRed
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        // 扫码配置按钮
        scanButton.setTitle("扫码配置", for: .normal)
        scanButton.backgroundColor = .systemBlue
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = 10
        scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        scanButton.addTarget(self, action: #selector(scanQRCode), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanButton)

        // 手动配置按钮
        manualButton.setTitle("手动配置", for: .normal)
        manualButton.backgroundColor = .systemGreen
        manualButton.setTitleColor(.white, for: .normal)
        manualButton.layer.cornerRadius = 10
        manualButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        manualButton.addTarget(self, action: #selector(manualInput), for: .touchUpInside)
        manualButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(manualButton)

        // 心跳检测按钮
        heartButton.setTitle("心跳检测", for: .normal)
        heartButton.backgroundColor = .systemOrange
        heartButton.setTitleColor(.white, for: .normal)
        heartButton.layer.cornerRadius = 10
        heartButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        heartButton.addTarget(self, action: #selector(checkHeartbeat), for: .touchUpInside)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartButton)

        // 测试通知按钮
        testButton.setTitle("发送测试通知", for: .normal)
        testButton.backgroundColor = .systemPurple
        testButton.setTitleColor(.white, for: .normal)
        testButton.layer.cornerRadius = 10
        testButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        testButton.addTarget(self, action: #selector(sendTestNotification), for: .touchUpInside)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testButton)

        // 说明标签
        let noteLabel = UILabel()
        noteLabel.text = "说明：iOS版本无法自动监听通知\n请确保服务端配置正确后开启心跳"
        noteLabel.font = UIFont.systemFont(ofSize: 12)
        noteLabel.textColor = .secondaryLabel
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteLabel)

        // 约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            hostLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 40),
            hostLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hostLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            keyLabel.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 16),
            keyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            statusLabel.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            scanButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            scanButton.heightAnchor.constraint(equalToConstant: 50),

            manualButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 16),
            manualButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            manualButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            manualButton.heightAnchor.constraint(equalToConstant: 50),

            heartButton.topAnchor.constraint(equalTo: manualButton.bottomAnchor, constant: 16),
            heartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            heartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            heartButton.heightAnchor.constraint(equalToConstant: 50),

            testButton.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: 16),
            testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            testButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            testButton.heightAnchor.constraint(equalToConstant: 50),

            noteLabel.topAnchor.constraint(equalTo: testButton.bottomAnchor, constant: 30),
            noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    // MARK: - Config Management
    private func loadConfig() {
        host = UserDefaults.standard.string(forKey: "vmq_host") ?? ""
        key = UserDefaults.standard.string(forKey: "vmq_key") ?? ""

        if !host.isEmpty && !key.isEmpty {
            hostLabel.text = "通知地址：\(host)"
            keyLabel.text = "通讯密钥：\(key)"
            isConfigured = true
            statusLabel.text = "状态：已配置"
            statusLabel.textColor = .systemGreen
        }
    }

    private func saveConfig(host: String, key: String) {
        UserDefaults.standard.set(host, forKey: "vmq_host")
        UserDefaults.standard.set(key, forKey: "vmq_key")
        self.host = host
        self.key = key
        isConfigured = true
        hostLabel.text = "通知地址：\(host)"
        keyLabel.text = "通讯密钥：\(key)"
        statusLabel.text = "状态：已配置"
        statusLabel.textColor = .systemGreen
    }

    // MARK: - Actions
    @objc private func scanQRCode() {
        let scannerVC = QRScannerViewController()
        scannerVC.delegate = self
        present(scannerVC, animated: true)
    }

    @objc private func manualInput() {
        let alert = UIAlertController(title: "手动配置", message: "请输入配置数据（格式：地址/密钥）", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "例如：example.com:8080/yourkey"
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确认", style: .default) { [weak self] _ in
            guard let input = alert.textFields?.first?.text else { return }
            self?.processConfig(input)
        })
        present(alert, animated: true)
    }

    private func processConfig(_ config: String) {
        let parts = config.split(separator: "/")
        guard parts.count == 2 else {
            showAlert(title: "错误", message: "数据格式错误，请输入网站上显示的配置数据！")
            return
        }

        let hostPart = String(parts[0])
        let keyPart = String(parts[1])

        // 验证配置
        NetworkService.shared.verifyConfig(host: hostPart, key: keyPart) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.saveConfig(host: hostPart, key: keyPart)
                    self?.showAlert(title: "成功", message: "配置成功！")
                } else {
                    self?.showAlert(title: "错误", message: message ?? "配置验证失败")
                }
            }
        }
    }

    @objc private func checkHeartbeat() {
        guard isConfigured else {
            showAlert(title: "提示", message: "请您先配置！")
            return
        }

        statusLabel.text = "状态：检测中..."
        statusLabel.textColor = .systemOrange

        NetworkService.shared.sendHeartbeat(host: host, key: key) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.statusLabel.text = "状态：心跳正常"
                    self?.statusLabel.textColor = .systemGreen
                    self?.startHeartbeat() // 启动定时心跳
                    self?.showAlert(title: "成功", message: message ?? "心跳正常")
                } else {
                    self?.statusLabel.text = "状态：心跳失败"
                    self?.statusLabel.textColor = .systemRed
                    self?.showAlert(title: "错误", message: message ?? "心跳失败，请检查配置！")
                }
            }
        }
    }

    @objc private func sendTestNotification() {
        // 发送本地测试通知
        let content = UNMutableNotificationContent()
        content.title = "V免签测试推送"
        content.body = "这是一条测试推送信息，如果程序正常，则会提示监听权限正常"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { [weak self] error in
            DispatchQueue.main.async {
                if error == nil {
                    self?.showAlert(title: "提示", message: "已发送测试通知！")
                } else {
                    self?.showAlert(title: "错误", message: "通知发送失败")
                }
            }
        }
    }

    // MARK: - Heartbeat
    private func startHeartbeat() {
        stopHeartbeat()
        heartTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            guard let self = self, self.isConfigured else { return }
            NetworkService.shared.sendHeartbeat(host: self.host, key: self.key) { _, _ in }
        }
    }

    private func stopHeartbeat() {
        heartTimer?.invalidate()
        heartTimer = nil
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - QRScannerDelegate
extension MainViewController: QRScannerDelegate {
    func didScanQRCode(_ code: String) {
        processConfig(code)
    }
}