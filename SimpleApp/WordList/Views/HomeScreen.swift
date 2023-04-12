//
//  HomeScreen.swift
//  SimpleApp
//
//  Created by Shazy on 20/03/23.
//

import SwiftUI

struct HomeScreen: View {
    let router: Router
    @State private var selection: String?
    let a = SemaphorePractice()
    init(router: Router) {
        self.router = router
    }
    
    var body: some View {
        TabView(selection: $selection) {
            router.getDictionarySearch()
                .tabItem {
                    Label("Search", systemImage: "rectangle.stack.badge.play")
                }
            
            router.getWordFlash()
                .tabItem {
                    Label("Practice", systemImage: "rectangle.stack.badge.play")
                }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(router: Router())
    }
}

class SemaphorePractice {
    
    init() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .utility)
        let semaphore = DispatchSemaphore(value: 2)
        
        
        for i in 0...10 {
            queue.async(group: group) {
                self.download(semaphore: semaphore, item: i)
            }
        }
        
        group.notify(queue: .main) {
            print("Downloading completed")
        }
    }
    
    func download(semaphore: DispatchSemaphore, item: Int) {
        semaphore.wait()
        defer { semaphore.signal() }
        
        print("\(item) Downloading Started")
        Thread.sleep(until: Date().addingTimeInterval(TimeInterval(item)))
        print("\(item) Downloading Ended")
    }
}
