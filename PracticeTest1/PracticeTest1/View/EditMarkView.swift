import SwiftUI

struct EditMarkView: View {
    @EnvironmentObject var manager: SchoolManager
    @Environment(\.dismiss) var dismiss
    let record: StudentRecord

    @State private var markText: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Subject") {
                    LabeledContent("Name",          value: record.subject.getName())
                    LabeledContent("ID",            value: record.subject.getID())
                    LabeledContent("Credits",       value: "\(record.subject.getCredits())")
                    LabeledContent("Academic Year", value: "\(record.academicYear)")
                }

                Section {
                    TextField("Enter mark (0 – 10)", text: $markText)
                        .keyboardType(.decimalPad)
                        .textContentType(.none)        
                        .autocorrectionDisabled()
                } header: {
                    Text("Mark")
                } footer: {
                    Text("Valid range: 0.0 – 10.0. A mark of 5.0 or higher is a pass.")
                        .font(.caption)
                }

                if let errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .font(.subheadline)
                            .foregroundColor(Theme.danger)
                    }
                }
            }
            .navigationTitle("Edit Mark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .bold()
                        .foregroundColor(Theme.marks)
                }
            }
            .onAppear {
                markText = String(format: "%.1f", record.getMark())
            }
        }
    }

    private func save() {
        let normalized = markText
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized) else {
            errorMessage = "Mark must be a valid number."
            return
        }
        do {
            try manager.updateMark(recordID: record.id, newMark: value)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    EditMarkView(record: SchoolManager.preview().records[0])
        .environmentObject(SchoolManager.preview())
}
