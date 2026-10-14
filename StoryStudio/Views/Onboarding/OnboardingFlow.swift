import SwiftUI

struct OnboardingFlow: View {
    @State private var showSplash = true
    @State private var onboardingStep: OnboardingStep = .overview
    @State private var selectedTemplate: StoryTemplate?

    enum OnboardingStep {
        case overview
        case getStarted
        case complete
    }

    var body: some View {
        if showSplash {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        } else {
            switch onboardingStep {
            case .overview:
                NavigationStack {
                    OverviewView { step in
                        if step == "getStarted" {
                            withAnimation {
                                onboardingStep = .getStarted
                            }
                        } else if step == "home" {
                            withAnimation {
                                onboardingStep = .complete
                            }
                        }
                    }
                }
            case .getStarted:
                NavigationStack {
                    GetStartedView {
                        withAnimation {
                            onboardingStep = .complete
                        }
                    }
                }
            case .complete:
                NavigationStack {
                    HomeView(selectedTemplate: $selectedTemplate)
                        .navigationDestination(isPresented: Binding(
                            get: { selectedTemplate != nil },
                            set: { if !$0 { selectedTemplate = nil } }
                        )) {
                            if let template = selectedTemplate {
                                StoryEditorView(template: template)
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    OnboardingFlow()
}
