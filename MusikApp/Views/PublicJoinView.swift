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
                Text("Host: \(room.id) Players: \(room.players?.count ?? 0)")
            }
            .onAppear {
                startPeriodicFetching()
            }
            .onDisappear {
                stopPeriodicFetching()
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
        
    }
    
    private func startPeriodicFetching() {
        print("fetching rooms...")
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
                    print("success", fetchedRooms);
                case .failure(let error):
                    print("Rooms fetch error: \(error)")
                }
            }
        }
    }
}
#Preview {
    PublicJoinView()
}

