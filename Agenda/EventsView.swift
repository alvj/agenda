import SwiftUI

struct EventsView: View {
    
    @State var events = [Event]()
    @State private var isPresentingNewEventView = false
    @State private var newEventName = ""
    @State private var newEventDate = Date()
    
    var body: some View {
        List(events, id: \.name) { event in
            HStack {
                Text(event.name ?? "")
                    .font(.headline)
                Spacer()
                Text(event.formattedDate)
                    .font(.caption)
            }
        }
        .task {
            await loadEvents()
        }
        .navigationTitle("Agenda")
        .listStyle(.plain)
        .toolbar() {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isPresentingNewEventView = true
                }, label: {
                    Image(systemName: "calendar.badge.plus")
                }).foregroundColor(Color.red)
            }
        }
        .font(.title)
        .sheet(isPresented: $isPresentingNewEventView) {
            NavigationView {
                VStack {
                    TextField(text: $newEventName) {
                        Text("Nombre")
                    }
                    DatePicker(selection: $newEventDate) {
                        Text("Fecha")
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            isPresentingNewEventView = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Guardar") {
                            createEvent(Event(name: newEventName, date: newEventDate.timeIntervalSince1970 * 1000))
                            isPresentingNewEventView = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    func loadEvents() async {
        guard let url = URL(string: "https://superapi.netlify.app/api/db/eventos") else {
            print("Invalid URL")
            return
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            print("Invalid response")
            return
        }
        
        do {
            let eventsResponse = try JSONDecoder().decode([Event].self, from: data)
            events = eventsResponse
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createEvent(_ event: Event) {
        guard let jsonData = try? JSONEncoder().encode(event) else {
            return
        }
        
        print(String(decoding: jsonData, as: UTF8.self))
        
        guard let url = URL(string: "https://superapi.netlify.app/api/db/eventos") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventsView()
        }
    }
}
