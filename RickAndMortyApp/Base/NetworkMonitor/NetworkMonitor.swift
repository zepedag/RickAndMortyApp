//
//  NetworkMonitor.swift
//  RickAndMortyApp
//
//  Created by Humberto Alejandro Zepeda González on 19/09/25.
//

import Foundation
import Network
import Observation

/// Service to monitor network connectivity status with stable detection
@Observable class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var connectivityTimer: Timer?
    private var isCurrentlyChecking = false

    // Estado y contadores para estabilidad
    private var consecutiveFailures: Int = 0
    private var consecutiveSuccesses: Int = 0
    private let requiredConsecutiveCount = 2  // Requiere 2 confirmaciones antes de cambiar (más rápido)

    var isConnected: Bool = false  // Empezar como desconectado hasta confirmar
    var connectionType: ConnectionType = .wifi  // Asumir Wi-Fi por defecto

    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }

    init() {
        startMonitoring()
        // Hacer un chequeo inmediato real al inicializar
        performInitialConnectivityCheck()
        startConnectivityChecks()
    }

    deinit {
        monitor.cancel()
        connectivityTimer?.invalidate()
    }

    /// Realiza un chequeo de conectividad inicial inmediato
    private func performInitialConnectivityCheck() {
        // Establecer tipo de conexión inicial desde NWPathMonitor
        let initialPath = monitor.currentPath
        connectionType = getConnectionType(from: initialPath)

        print("🌐 NetworkMonitor: Initial connection type: \(connectionTypeDescription)")

        // Hacer un chequeo real inmediato para determinar el estado de conexión
        guard let url = URL(string: "https://www.google.com/generate_204") else {
            isConnected = false
            print("❌ NetworkMonitor: Initial check failed - invalid URL")
            return
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 2.0  // Timeout más agresivo para detección rápida
        config.timeoutIntervalForResource = 2.0
        config.waitsForConnectivity = false
        config.allowsCellularAccess = true
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: url) { [weak self] _, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let isActuallyConnected = error == nil && (response as? HTTPURLResponse)?.statusCode == 204
                self.isConnected = isActuallyConnected

                // Inicializar contadores basados en el resultado inicial
                if isActuallyConnected {
                    self.consecutiveSuccesses = self.requiredConsecutiveCount  // Ya confirmado
                    self.consecutiveFailures = 0
                    print("✅ NetworkMonitor: Initial state - CONNECTED")
                } else {
                    self.consecutiveFailures = self.requiredConsecutiveCount  // Ya confirmado
                    self.consecutiveSuccesses = 0
                    print("❌ NetworkMonitor: Initial state - DISCONNECTED")
                }

                print("🔍 NetworkMonitor: Initial Status - Connected=\(self.isConnected), Type=\(self.connectionTypeDescription)")
            }
        }
        task.resume()
    }

    private func startMonitoring() {
        // NWPathMonitor solo para detectar el tipo de conexión
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let newConnectionType = self.getConnectionType(from: path)
                if self.connectionType != newConnectionType {
                    self.connectionType = newConnectionType
                    print("🌐 NWPathMonitor: Connection type updated to: \(self.connectionTypeDescription)")
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func getConnectionType(from path: NWPath) -> ConnectionType {
        // Si no hay conexión, mantener el tipo anterior o asumir Wi-Fi
        guard path.status == .satisfied else {
            // Mantener el tipo actual si ya tenemos uno válido, sino asumir Wi-Fi
            return connectionType != .unknown ? connectionType : .wifi
        }

        // Verificar múltiples interfaces y priorizar por orden de preferencia
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.loopback) {
            // Loopback generalmente indica conexión local/simulador
            return .wifi // Asumir Wi-Fi para simulador
        } else {
            // Si hay conexión pero no podemos determinar el tipo específico
            // Revisar si tenemos interfaces disponibles
            let availableInterfaces = path.availableInterfaces
            if !availableInterfaces.isEmpty {
                // Si hay interfaces disponibles, probablemente es Wi-Fi
                return .wifi
            } else {
                // Como último recurso, asumir Wi-Fi (más común)
                return .wifi
            }
        }
    }

    var connectionTypeIcon: String {
        switch connectionType {
        case .wifi:
            return "wifi"
        case .cellular:
            return "antenna.radiowaves.left.and.right"
        case .ethernet:
            return "cable.connector"
        case .unknown:
            return "questionmark.circle"
        }
    }

    var connectionTypeDescription: String {
        switch connectionType {
        case .wifi:
            return "Wi-Fi"
        case .cellular:
            return "Cellular"
        case .ethernet:
            return "Ethernet"
        case .unknown:
            return "Unknown"
        }
    }

    /// Inicia chequeos de conectividad estables con múltiples confirmaciones
    private func startConnectivityChecks() {
        connectivityTimer?.invalidate()

        // Chequeos más frecuentes para detección rápida
        connectivityTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.performStableConnectivityCheck()
        }
    }

    /// Realiza un chequeo de conectividad que requiere múltiples confirmaciones
    private func performStableConnectivityCheck() {
        // Solo hacer check si no estamos ya verificando
        guard !isCurrentlyChecking else { return }

        isCurrentlyChecking = true

        // Usar endpoint simple y confiable
        guard let url = URL(string: "https://www.google.com/generate_204") else {
            isCurrentlyChecking = false
            return
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 2.0  // Timeout agresivo para detección rápida
        config.timeoutIntervalForResource = 2.0
        config.waitsForConnectivity = false
        config.allowsCellularAccess = true
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: url) { [weak self] _, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let isActuallyConnected = error == nil && (response as? HTTPURLResponse)?.statusCode == 204

                print("🔍 Stable Check: Google 204 test - Success: \(isActuallyConnected)")

                self.updateConnectionState(isConnected: isActuallyConnected)
                self.isCurrentlyChecking = false
            }
        }
        task.resume()
    }

    /// Actualiza el estado de conexión con sistema de confirmaciones múltiples
    private func updateConnectionState(isConnected: Bool) {
        if isConnected {
            consecutiveSuccesses += 1
            consecutiveFailures = 0

            // Solo cambiar a conectado después de X confirmaciones consecutivas
            if consecutiveSuccesses >= requiredConsecutiveCount && !self.isConnected {
                self.isConnected = true
                print("✅ FAST: CONNECTION RESTORED after \(consecutiveSuccesses) confirmations")

                // Asegurar que tenemos un tipo de conexión válido cuando se restaura
                if connectionType == .unknown {
                    connectionType = .wifi
                    print("🔧 NetworkMonitor: Set connection type to Wi-Fi (was unknown)")
                }
            }
        } else {
            consecutiveFailures += 1
            consecutiveSuccesses = 0

            // Solo cambiar a desconectado después de X confirmaciones consecutivas
            if consecutiveFailures >= requiredConsecutiveCount && self.isConnected {
                self.isConnected = false
                print("❌ FAST: CONNECTION LOST after \(consecutiveFailures) confirmations")

                // Al perder conexión, mantener el último tipo conocido (no cambiar a unknown)
                // Esto evita que aparezca "?" cuando se pierde la conexión
                print("🔧 NetworkMonitor: Keeping connection type as \(connectionTypeDescription) while disconnected")
            }
        }

        print("🔍 Stability Status: Connected=\(self.isConnected), Type=\(connectionTypeDescription), Successes=\(consecutiveSuccesses), Failures=\(consecutiveFailures)")
    }

    /// Forces an immediate connectivity check
    func forceConnectivityCheck() {
        print("🔍 NetworkMonitor: Forcing immediate connectivity check...")
        performStableConnectivityCheck()
    }
}
