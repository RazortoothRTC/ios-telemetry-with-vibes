//
//  ContentView.swift
//  WatashiTelemetryApp
//
//  Created by David J kordsmeier on 2/3/26.
//

import SwiftUI
import Network

struct ContentView: View {
    @State private var counter = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let udpConnection = NWConnection(
        host: "YOUR_MAC_IP",
        port: 9001,
        using: .udp
    )

    var body: some View {
        VStack(spacing: 20) {
            Text("HTTP + UDP logging")
                .font(.headline)

            Text("Count: \(counter)")
                .font(.largeTitle)
                .monospacedDigit()
        }
        .onAppear {
            udpConnection.start(queue: .global())
        }
        .onReceive(timer) { _ in
            counter += 1
            sendHTTP(counter: counter)
            sendUDP(counter: counter)
        }
        .padding()
    }

    // -------------------------
    // HTTP JSON (existing)
    // -------------------------
    func sendHTTP(counter: Int) {
        guard let url = URL(string: "http://YOUR_MAC_IP:9000") else { return }

        let payload: [String: Any] = [
            "message": "tick",
            "counter": counter,
            "timestamp": Date().timeIntervalSince1970
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: payload) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        URLSession.shared.dataTask(with: request).resume()
    }

    // -------------------------
    // UDP CSV (new)
    // -------------------------
    func sendUDP(counter: Int) {
        let ts = Date().timeIntervalSince1970
        let csv = "\(ts),\(counter),tick\n"

        udpConnection.send(
            content: csv.data(using: .utf8),
            completion: .contentProcessed { _ in }
        )
    }
}
