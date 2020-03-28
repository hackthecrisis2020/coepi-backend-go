import Foundation

struct Symptom : Codable {
  let symptomID: Int64
  let timestamp: Date
  let symptoms: String
}
