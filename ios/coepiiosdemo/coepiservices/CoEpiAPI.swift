/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class CoEpiAPI {
  let server = "coepi.wolk.com"
  let httpport = "8080"
  
  private func generateEndpoint(action: String) -> String {
    return "https://" + self.server + ":" + httpport + "/" + action
  }
  
    private func postSymptoms(sr: CENReport) {
      print("SymptomsReport", sr)
      let endpoint = generateEndpoint(action: "symptoms")
      let method = "POST"
      let encodedEAS = try! JSONEncoder().encode(sr)
      makeAPICall(endpoint: endpoint, method: method, body: encodedEAS)
    }
    
    private func sendExposureAndSymptoms(eas: ExposureAndSymptoms) {
    print("ExposureAndSymptoms", eas)
    let endpoint = generateEndpoint(action: "exposureandsymptoms")
    let method = "POST"
    let encodedEAS = try! JSONEncoder().encode(eas)
    makeAPICall(endpoint: endpoint, method: method, body: encodedEAS)
  }
  
  private func sendExposureCheck(ec: ExposureCheck) {
    print("sendExposureCheck")
    let endpoint = generateEndpoint(action: "exposurecheck")
    let method = "POST"
    let encodedEC = try! JSONEncoder().encode(ec)
    makeAPICall(endpoint: endpoint, method: method, body: encodedEC)
  }

  private func makeAPICall(endpoint: String, method: String, body: Data) {
    
     //var error: Unmanaged<CFError>?
     let config = URLSessionConfiguration.default
     config.waitsForConnectivity = true
     guard let URLObject = URL(string: endpoint) else {
         print("INVALID URL!")
         return
     }
     var req = URLRequest(url: URLObject)
     req.httpMethod = method
     req.httpBody = body
     
     print("making url request \(req)")
     URLSession(configuration: config).dataTask(with: req) { data, response, error in
         print("start closure in request")
         if let error = error {
             print(error.localizedDescription)
         }
         // use your data here
         // TODO: on Wait, use a long timeout, but not for all the others!

         if let error = error {
             //TODO: self.handleClientError(error)
             print("ERROR: \(error)")
             //errorHandler(error)
             return
         }
         guard let httpResponse = response as? HTTPURLResponse,
             (200...299).contains(httpResponse.statusCode) else {
                 print("http response status code is: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
             //TODO: self.handleServerError(response)
             return
         }
         
         //TODO: determine where/when this should / can be called
         //successHandler(data, httpResponse)
         print("data success")
     }.resume()
  }
}
