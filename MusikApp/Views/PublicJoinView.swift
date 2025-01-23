//
//  JoinStageView.swift
//  MusikApp
//
//  Created by Christian Koch Echeverria on 26.12.24.
//

import Foundation
import SwiftUI

struct PublicJoinView: View {
    @State private var rooms: [Room] = []
    @State private var selectedRoomId: String?
    @State private var timer: Timer?
    let apiService = ServerComsController()
    var body: some View {
        NavigationStack {
            List(rooms, id: \.id, selection: $selectedRoomId) { room in
                VStack(alignment: .leading) {
                    Text(room.id ?? "Unknown Room")
                    Text("Host: \(room.host.name)")
                    Text("Players: \(room.players?.count ?? 0)")
                    if let status = room.status {
                        Text("Status: \(status.rawValue)")
                    }
                }
            }
            .navigationTitle("Rooms (public)")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Join Room") {
                        print("joining \(selectedRoomId ?? "NO_SELECTED_ROOM")...")
                    }
                    .disabled(selectedRoomId == nil)
                }
            }
        }
        .onAppear {
            startPeriodicFetching()
        }
        .onDisappear {
            stopPeriodicFetching()
        }
    }
    
    private func startPeriodicFetching() {
        fetchRooms()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            fetchRooms()
        }
    }
    
    private func stopPeriodicFetching() {
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchRooms() {
        apiService.getAllRooms { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRooms):
                    rooms = fetchedRooms
                case .failure(let error):
                    print("Rooms fetch error: \(error.localizedDescription)")
                }
            }
        }
    }
}
#Preview {
    PublicJoinView()
}

