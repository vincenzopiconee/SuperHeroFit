import SwiftUI
import SwiftData

struct HomeView: View {
    
    let texts = [
        "Today is your day, make it count!",
        "Small steps every day lead to big results.",
        "Start strong, finish stronger.",
        "You’ve got this, one step at a time.",
        "Every move you make is progress.",
        "Push yourself, you’re stronger than you think.",
        "Keep going, greatness is on the other side of effort.",
        "Believe in yourself and keep moving forward.",
        "Every day is a chance to be better than yesterday.",
        "Focus on progress, not perfection.",
        "Take one more step, you’re closer than you think.",
        "You’re capable of amazing things.",
        "Your hard work will pay off.",
        "Small efforts each day add up to big change.",
        "Challenge yourself, you’re stronger than you know.",
        "One step today is closer to your goals tomorrow.",
        "Stay positive, stay active, stay strong.",
        "Your future self will thank you for today’s efforts.",
        "Keep pushing; every step brings you closer.",
        "You can do this, believe in yourself!",
        "Great things never come from comfort zones.",
        "Take a deep breath and crush today’s goals.",
        "Your strength grows with every challenge.",
        "Dream big, work hard, stay focused.",
        "The only limit is the one you set for yourself.",
        "Don’t give up, success is around the corner.",
        "You’re one day closer to achieving your goals.",
        "Get up, get moving, and give it your all.",
        "Your effort today fuels your success tomorrow.",
        "Stay focused, stay driven, stay strong.",
        "Make today a victory for your future self.",
        "One day at a time, you’re making progress.",
        "Rise up to the challenge; greatness awaits.",
        "You have everything it takes to succeed.",
        "Believe in the power of your own strength.",
        "Every small win is a step closer to your goals.",
        "The journey is tough, but the reward is worth it.",
        "You’re unstoppable when you set your mind to it.",
        "Keep going; every effort is a step forward.",
        "Today is a new opportunity to become your best."
    ]
    
    @Query var users: [User]
    @Query var challenges: [Challenge]  // Per recuperare le challenge
    
    @State private var currentText: String = ""
    @State private var isChallengeSheetPresented: Bool = false  // Variabile per gestire la presentazione dello sheet
    @State private var activeChallenge: Challenge?  // Per tenere traccia della challenge attiva
    
    // Funzione per ottenere il testo del giorno
    func getTextForToday() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: currentDate) ?? 0
        let index = dayOfYear % texts.count
        return texts[index]
    }
    
    var body: some View {
        NavigationStack (){
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        Spacer() // Usa questo per dare spazio senza influire sui layout
                        AvatarView(mask: users.first?.mask, cape: users.first?.cape, gloves: users.first?.gloves, other: users.first?.other)
                        Spacer()
                    }
                    // Elementi fissi usando posizionamento assoluto
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 318.0, height: 55)
                                .background(
                                    Color.gray // Sfondo grigio chiaro opaco
                                        .blur(radius: 40)
                                )
                                .overlay(
                                    Color.black.opacity(0.01) // Profondità con un overlay scuro
                                        .blur(radius: 40)
                                )
                                .cornerRadius(22.1)
                            
                            Text(currentText)
                                .font(.custom("Arial-ItalicMT", size: 17))
                                .foregroundColor(.primary) // Colore adattivo per il testo
                                .multilineTextAlignment(.center)
                                .frame(width: 300, alignment: .center)
                                .onAppear {
                                    currentText = getTextForToday()
                                    startDailyTextChange()
                                }
                        }
                        .position(x: geometry.size.width / 2, y: 50)
                        
                        Spacer()
                        
                        // Tasto per la challenge attiva o nuova challenge
                        if let challenge = activeChallenge, challenge.isCompleted == false {
                            // Se esiste una challenge attiva non completata, mostra il tasto "View Active Challenge"
                            NavigationLink(destination: ActiveChallengeView()) {
                                Text("Active Challenge")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.accentColor)
                                    .cornerRadius(25)
                                    .padding()
                            }
                            .position(x: geometry.size.width / 2, y: 230)
                            
                        } else {
                            // Se non c'è una challenge attiva, mostra il tasto "New Challenge"
                            Button(action: {
                                isChallengeSheetPresented.toggle()  // Mostra il sheet per creare una nuova challenge
                            }) {
                                Text("New Challenge")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.accentColor)
                                    .cornerRadius(25)
                                    .padding()
                            }
                            .position(x: geometry.size.width / 2, y: 230)
                            .sheet(isPresented: $isChallengeSheetPresented) {
                                ChallengeSetupView()  // La vista da presentare nel sheet
                            }
                        }
                    }
                }
            }
            .navigationTitle("SuperHeroFit")
            .navigationBarItems(leading: NavigationLink(
                destination: SettingsView(),
                label: {
                    Image(systemName: "gear")
                }), trailing: NavigationLink(
                    destination: ProfileView(),
                    label: {
                        Image(systemName: "person")
                    })
            )
        }
        .onAppear {
            updateActiveChallenge()
        }
        .onChange(of: challenges) {
            updateActiveChallenge()
        }
    }
    
    func updateActiveChallenge() {
        // Se non ci sono challenge non completate, mostra il tasto per una nuova challenge
        if let challenge = challenges.first(where: { !$0.isCompleted }) {
            activeChallenge = challenge  // Imposta la challenge attiva
        } else {
            activeChallenge = nil  // Se non ci sono challenge attive, imposta a nil
        }
        
    }
    
    // Funzione per avviare il cambio del testo quotidiano
    func startDailyTextChange() {
        let calendar = Calendar.current
        let currentDate = Date()
        let nextMidnight = calendar.nextDate(after: currentDate, matching: .init(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        let timeInterval = nextMidnight.timeIntervalSince(currentDate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            currentText = getTextForToday()
            startDailyTextChange()
        }
    }
}

#Preview {
    HomeView()
        .environment(\.colorScheme, .dark)
}
